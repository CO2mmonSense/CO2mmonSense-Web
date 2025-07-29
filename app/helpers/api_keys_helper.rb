module ApiKeysHelper
    def display_api_key(api_key)
        secret_placeholder = "*" * 24
        return [api_key.common_prefix, api_key.random_prefix, secret_placeholder].join("_")
    end

    def display_expiration_status(api_key)
        if api_key.expires_at.nil?
        "Never"
        elsif api_key.expires_at < Time.current
        "Expired"
        else
        "in #{distance_of_time_in_words(Time.current, api_key.expires_at)}"
        end
    end
end
