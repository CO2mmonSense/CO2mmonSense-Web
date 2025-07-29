class ApiKey < ApplicationRecord
    belongs_to :bearer, polymorphic: true

    before_validation :generate_token, on: :create

    attr_accessor :raw_token

    def self.authenticate(token)
        return false if token.blank?

        api_key = find_by(token_digest: Digest::SHA256.hexdigest(token))
        return false unless api_key
        
        !api_key.expired?
    end

    def expired?
        expires_at? && expires_at < Time.current
    end

    private

    def generate_token
        common_prefix = "sk_usr"
        random_prefix = SecureRandom.base58(6)
        secret = SecureRandom.base58(24)
        raw_token = [common_prefix, random_prefix, secret].join("_")
        
        self.common_prefix = common_prefix
        self.random_prefix = random_prefix
        self.token_digest = Digest::SHA256.hexdigest(raw_token)
        self.raw_token = raw_token
    end
end
