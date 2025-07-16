const express = require('express');
const router = express.Router();
const c = require('../controllers/quoteController');


router.get('/', c.getQuotes);
router.get('/favorites', c.getFavoriteQuotes);
router.post('/', c.addQuote);
router.delete('/:id', c.deleteQuote);
router.put('/:id/favorite', c.toggleFavorite);

module.exports = router;
