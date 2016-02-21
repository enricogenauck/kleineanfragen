class NotifyPuSHHubBodyFeedJob < ActiveJob::Base
  include ActiveJob::Retry

  queue_as :subscription

  variable_retry delays: [5, 15, 30, 90],
                 retryable_exceptions: [Excon::Errors::Timeout]

  def perform(body)
    return if Rails.configuration.x.push_hub.blank?

    feed_url = Rails.application.routes.url_helpers.body_feed_url(body: body, format: :atom)

    response = Excon.post(
      Rails.configuration.x.push_hub,
      body: URI.encode_www_form(
        'hub.mode' => 'publish',
        'hub.url' => feed_url
      ),
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
    )

    fail "Couldn't get response, status #{response.status}" unless [200, 204].include?(response.status)
  end
end