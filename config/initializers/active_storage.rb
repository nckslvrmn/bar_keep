# Configure Active Storage proxy controllers to set cache headers
Rails.application.config.to_prepare do
  # The proxy controllers in Active Storage already set cache headers,
  # but they use a 5-minute expiration by default. Let's increase it to 1 day.

  if defined?(ActiveStorage::Blobs::ProxyController)
    ActiveStorage::Blobs::ProxyController.class_eval do
      private

      # Override to set 1-day cache instead of default 5 minutes
      def set_cache_control
        expires_in 1.day, public: true
      end
    end
  end

  if defined?(ActiveStorage::Representations::ProxyController)
    ActiveStorage::Representations::ProxyController.class_eval do
      private

      # Override to set 1-day cache instead of default 5 minutes
      def set_cache_control
        expires_in 1.day, public: true
      end
    end
  end
end
