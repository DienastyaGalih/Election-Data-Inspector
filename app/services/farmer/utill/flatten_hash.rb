module Farmer
  module Utill
    class FlattenHash < ActiveInteraction::Base
      hash :hash_data, strip: false
      string :delimiter, default: '.'

      def execute
        flatten_hash(hash_data, '', delimiter)
      end

      private

      def flatten_hash(hsh, keypath = '', delimiter = '.')
        hsh.reduce({}) do |m, (k, v)|
          new_key = keypath.empty? ? "#{k}" : "#{keypath}#{delimiter}#{k}"
          if v.is_a? Hash
            m.merge(flatten_hash(v, new_key, delimiter))
          else
            m[new_key] = v
            m
          end
        end
      end
    end
  end
end
