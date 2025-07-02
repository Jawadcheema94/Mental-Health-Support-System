const express = require('express');
const router = express.Router();
const { validatePayment } = require('../middleware/validators');
const PaymentController = require('../controllers/paymentController');

router.get('/', PaymentController.getAllPayments);
router.get('/user/:id', PaymentController.getPaymentById);
router.post('/', validatePayment, PaymentController.createPayment);
router.put('/:id', validatePayment, PaymentController.updatePayment);
router.post('/:id/refund', PaymentController.processRefund);
router.get('/user/:userId', PaymentController.getUserPayments);

module.exports = router;