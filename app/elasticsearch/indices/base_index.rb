module Indices
  class BaseIndex < ::Chewy::Index
    settings analysis: {
      tokenizer: 'standard'
    }
  end
end
