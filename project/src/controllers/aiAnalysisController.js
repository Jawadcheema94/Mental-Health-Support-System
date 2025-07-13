const { JournalEntry, User } = require('../models');
const axios = require('axios');

class AIAnalysisController {
  // Analyze journal entry using AI model
  static async analyzeJournalEntry(req, res, next) {
    try {
      const { journalEntryId, userId } = req.params;
      const { content } = req.body;

      // Validate user
      const user = await User.findById(userId);
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      // Get journal entry if ID provided, otherwise use content from body
      let journalContent = content;
      if (journalEntryId) {
        const journalEntry = await JournalEntry.findById(journalEntryId);
        if (!journalEntry) {
          return res.status(404).json({ message: 'Journal entry not found' });
        }
        journalContent = journalEntry.content;
      }

      if (!journalContent) {
        return res.status(400).json({ message: 'No content to analyze' });
      }

      // Perform AI analysis
      const analysis = await AIAnalysisController.performAIAnalysis(journalContent);

      // Save analysis results
      const analysisResult = {
        userId,
        journalEntryId: journalEntryId || null,
        content: journalContent,
        analysis,
        timestamp: new Date(),
      };

      res.status(200).json({
        message: 'Analysis completed successfully',
        result: analysisResult,
      });

    } catch (error) {
      console.error('Error in AI analysis:', error);
      res.status(500).json({ 
        message: 'Error performing AI analysis', 
        error: error.message 
      });
    }
  }

  // Get user's analysis history
  static async getUserAnalysisHistory(req, res, next) {
    try {
      const { userId } = req.params;
      const { limit = 10, page = 1 } = req.query;

      // Validate user
      const user = await User.findById(userId);
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      // Get journal entries with analysis
      const journalEntries = await JournalEntry.find({ userId })
        .sort({ entryDate: -1 })
        .limit(parseInt(limit))
        .skip((parseInt(page) - 1) * parseInt(limit));

      // Perform analysis on each entry
      const analysisHistory = await Promise.all(
        journalEntries.map(async (entry) => {
          const analysis = await AIAnalysisController.performAIAnalysis(entry.content);
          return {
            entryId: entry._id,
            date: entry.entryDate,
            content: entry.content,
            analysis,
          };
        })
      );

      res.status(200).json({
        message: 'Analysis history retrieved successfully',
        data: analysisHistory,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total: await JournalEntry.countDocuments({ userId }),
        },
      });

    } catch (error) {
      console.error('Error getting analysis history:', error);
      res.status(500).json({ 
        message: 'Error retrieving analysis history', 
        error: error.message 
      });
    }
  }

  // Perform AI analysis using the BERT model
  static async performAIAnalysis(content) {
    try {
      // Simulate AI analysis (replace with actual model integration)
      const analysis = {
        mentalHealthStatus: AIAnalysisController.classifyMentalHealth(content),
        sentimentScore: AIAnalysisController.calculateSentiment(content),
        emotionalIndicators: AIAnalysisController.extractEmotionalIndicators(content),
        riskLevel: AIAnalysisController.assessRiskLevel(content),
        recommendations: AIAnalysisController.generateRecommendations(content),
        keyThemes: AIAnalysisController.extractKeyThemes(content),
        confidenceScore: Math.random() * 0.3 + 0.7, // 0.7-1.0
      };

      return analysis;
    } catch (error) {
      console.error('Error in AI analysis:', error);
      throw new Error('Failed to perform AI analysis');
    }
  }

  // Classify mental health status using keywords and patterns
  static classifyMentalHealth(content) {
    const text = content.toLowerCase();
    
    const patterns = {
      anxiety: ['anxious', 'worried', 'nervous', 'panic', 'fear', 'stress', 'overwhelmed'],
      depression: ['sad', 'depressed', 'hopeless', 'empty', 'worthless', 'tired', 'lonely'],
      positive: ['happy', 'joy', 'excited', 'grateful', 'confident', 'peaceful', 'content'],
      neutral: ['okay', 'normal', 'fine', 'regular', 'usual']
    };

    let scores = { anxiety: 0, depression: 0, positive: 0, neutral: 0 };

    for (const [category, keywords] of Object.entries(patterns)) {
      keywords.forEach(keyword => {
        if (text.includes(keyword)) {
          scores[category]++;
        }
      });
    }

    const maxCategory = Object.keys(scores).reduce((a, b) => 
      scores[a] > scores[b] ? a : b
    );

    return {
      primary: maxCategory,
      scores,
      confidence: Math.max(...Object.values(scores)) / content.split(' ').length
    };
  }

  // Calculate sentiment score
  static calculateSentiment(content) {
    const positiveWords = ['good', 'great', 'happy', 'love', 'amazing', 'wonderful', 'excellent'];
    const negativeWords = ['bad', 'terrible', 'hate', 'awful', 'horrible', 'sad', 'angry'];
    
    const words = content.toLowerCase().split(/\s+/);
    let score = 0;

    words.forEach(word => {
      if (positiveWords.includes(word)) score += 1;
      if (negativeWords.includes(word)) score -= 1;
    });

    return {
      score: score / words.length,
      label: score > 0 ? 'positive' : score < 0 ? 'negative' : 'neutral'
    };
  }

  // Extract emotional indicators
  static extractEmotionalIndicators(content) {
    const emotions = {
      joy: ['happy', 'joy', 'excited', 'cheerful', 'delighted'],
      sadness: ['sad', 'cry', 'tears', 'grief', 'sorrow'],
      anger: ['angry', 'mad', 'furious', 'rage', 'irritated'],
      fear: ['scared', 'afraid', 'terrified', 'anxious', 'worried'],
      surprise: ['surprised', 'shocked', 'amazed', 'astonished'],
      disgust: ['disgusted', 'revolted', 'sick', 'nauseated']
    };

    const detected = {};
    const text = content.toLowerCase();

    for (const [emotion, keywords] of Object.entries(emotions)) {
      const count = keywords.filter(keyword => text.includes(keyword)).length;
      if (count > 0) {
        detected[emotion] = count;
      }
    }

    return detected;
  }

  // Assess risk level
  static assessRiskLevel(content) {
    const highRiskKeywords = ['suicide', 'kill myself', 'end it all', 'no point', 'give up'];
    const mediumRiskKeywords = ['hopeless', 'worthless', 'can\'t go on', 'too much'];
    const lowRiskKeywords = ['stressed', 'tired', 'overwhelmed', 'difficult'];

    const text = content.toLowerCase();
    
    if (highRiskKeywords.some(keyword => text.includes(keyword))) {
      return { level: 'high', urgency: 'immediate', recommendation: 'Seek professional help immediately' };
    } else if (mediumRiskKeywords.some(keyword => text.includes(keyword))) {
      return { level: 'medium', urgency: 'soon', recommendation: 'Consider speaking with a counselor' };
    } else if (lowRiskKeywords.some(keyword => text.includes(keyword))) {
      return { level: 'low', urgency: 'monitor', recommendation: 'Practice self-care and monitor mood' };
    }
    
    return { level: 'minimal', urgency: 'none', recommendation: 'Continue healthy habits' };
  }

  // Generate recommendations
  static generateRecommendations(content) {
    const text = content.toLowerCase();
    const recommendations = [];

    if (text.includes('stress') || text.includes('overwhelmed')) {
      recommendations.push('Try deep breathing exercises or meditation');
      recommendations.push('Consider breaking tasks into smaller, manageable steps');
    }

    if (text.includes('sad') || text.includes('depressed')) {
      recommendations.push('Engage in physical activity or exercise');
      recommendations.push('Connect with friends or family members');
      recommendations.push('Consider professional counseling');
    }

    if (text.includes('anxious') || text.includes('worried')) {
      recommendations.push('Practice mindfulness or grounding techniques');
      recommendations.push('Limit caffeine intake');
      recommendations.push('Establish a regular sleep schedule');
    }

    if (recommendations.length === 0) {
      recommendations.push('Continue journaling to track your emotional well-being');
      recommendations.push('Maintain healthy lifestyle habits');
    }

    return recommendations;
  }

  // Extract key themes
  static extractKeyThemes(content) {
    const themes = {
      work: ['work', 'job', 'career', 'boss', 'colleague', 'office'],
      relationships: ['family', 'friend', 'partner', 'relationship', 'love', 'marriage'],
      health: ['health', 'sick', 'doctor', 'medicine', 'pain', 'tired'],
      finance: ['money', 'financial', 'debt', 'expensive', 'budget', 'income'],
      education: ['school', 'study', 'exam', 'grade', 'teacher', 'student']
    };

    const detected = {};
    const text = content.toLowerCase();

    for (const [theme, keywords] of Object.entries(themes)) {
      const count = keywords.filter(keyword => text.includes(keyword)).length;
      if (count > 0) {
        detected[theme] = count;
      }
    }

    return Object.keys(detected).sort((a, b) => detected[b] - detected[a]);
  }
}

module.exports = AIAnalysisController;
