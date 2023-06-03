module Indices
  class BaseIndex < ::Chewy::Index
    settings analysis: {
      analyzer: {
        ngram_analyzer: {
          tokenizer: 'edge_ngram_tokenizer',
          filter: ['lowercase']
        }
      },
      tokenizer: {
        edge_ngram_tokenizer: {
          type: 'edge_ngram',
          min_gram: 3,
          max_gram: 5,
          token_chars: %w[letter digit],
          max_ngram_diff: '5'
        }
      }
    }
  end
end
