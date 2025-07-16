const Quote = require('../models/quote');

exports.getQuotes = async (req, res) => {
  const quotes = await Quote.find().sort({ createdAt: -1 });
  res.json(quotes);
};

exports.addQuote = async (req, res) => {
  const { text, author, category } = req.body;
  const quote = new Quote({ text, author, category });
  await quote.save();
  res.json(quote);
};

exports.deleteQuote = async (req, res) => {
  await Quote.findByIdAndDelete(req.params.id);
  res.json({ message: 'Deleted' });
};


exports.toggleFavorite = async (req, res) => {
  const { isFavorite } = req.body;
  const quote = await Quote.findByIdAndUpdate(req.params.id, { isFavorite }, { new: true });
  res.json(quote);
};

exports.getFavoriteQuotes = async (req, res) => {
  const favorites = await Quote.find({ isFavorite: true }).sort({ createdAt: -1 });
  res.json(favorites);
};
