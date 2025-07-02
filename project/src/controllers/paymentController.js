const { Payment, User } = require('../models');

class PaymentController {
  static async getAllPayments(req, res, next) {
    try {
      const payments = await Payment.find()
        .populate('userId', 'username email')
        .sort({ createdAt: -1 });

      // Transform data for admin view
      const transformedPayments = payments.map(payment => ({
        _id: payment._id,
        userEmail: payment.userId?.email || 'Unknown User',
        therapistEmail: payment.therapistEmail || 'Unknown Therapist',
        amount: payment.amount,
        status: payment.status || payment.transactionStatus,
        paymentMethod: payment.paymentMethod || 'Card',
        stripePaymentId: payment.stripePaymentId,
        appointmentId: payment.appointmentId,
        createdAt: payment.createdAt || payment.paymentDate,
        refundedAt: payment.refundedAt
      }));

      res.json(transformedPayments);
    } catch (error) {
      next(error);
    }
  }

  static async getPaymentById(req, res, next) {
    try {
      const payment = await Payment.findById(req.params.id)
        .populate('userId', '-passwordHash');
      
      if (!payment) {
        return res.status(404).json({ message: 'Payment not found' });
      }
      
      res.json(payment);
    } catch (error) {
      next(error);
    }
  }

  static async createPayment(req, res, next) {
    try {
      const { userId, amount } = req.body;
      
      const payment = new Payment({
        userId,
        amount,
        paymentDate: new Date(),
        transactionStatus: 'Pending',
      });

      await payment.save();

      // Update user's payment references
      await User.findByIdAndUpdate(userId, {
        $push: { paymentIds: payment._id },
      });

      res.status(201).json(payment);
    } catch (error) {
      next(error);
    }
  }

  static async updatePayment(req, res, next) {
    try {
      const { transactionStatus } = req.body;
      
      const payment = await Payment.findByIdAndUpdate(
        req.params.id,
        { transactionStatus },
        { new: true }
      );

      if (!payment) {
        return res.status(404).json({ message: 'Payment not found' });
      }

      res.json(payment);
    } catch (error) {
      next(error);
    }
  }

  static async getUserPayments(req, res, next) {
    try {
      const payments = await Payment.find({ userId: req.params.userId })
        .sort({ paymentDate: -1 });
      
      res.json(payments);
    } catch (error) {
      next(error);
    }
  }

  static async processRefund(req, res, next) {
    try {
      const { id } = req.params;

      const payment = await Payment.findById(id);
      if (!payment) {
        return res.status(404).json({ message: 'Payment not found' });
      }

      if (payment.status === 'Refunded') {
        return res.status(400).json({ message: 'Payment already refunded' });
      }

      if (payment.status !== 'Completed') {
        return res.status(400).json({ message: 'Can only refund completed payments' });
      }

      // Update payment status to refunded
      payment.status = 'Refunded';
      payment.refundedAt = new Date();
      await payment.save();

      // In a real implementation, you would also process the refund through Stripe
      // const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
      // await stripe.refunds.create({
      //   payment_intent: payment.stripePaymentId,
      // });

      res.json({
        message: 'Refund processed successfully',
        payment
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = PaymentController;