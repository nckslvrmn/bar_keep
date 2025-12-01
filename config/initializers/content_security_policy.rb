Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, :https, :data, :blob
  policy.object_src  :none
  policy.script_src  :self, :https, "https://cdnjs.cloudflare.com"
  policy.style_src   :self, :https, :unsafe_inline, "https://cdnjs.cloudflare.com"
  policy.connect_src :self, :https

  if Rails.env.development?
    policy.script_src :self, :https, :unsafe_eval, :unsafe_inline, "https://cdnjs.cloudflare.com"
  end
end

Rails.application.config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
Rails.application.config.content_security_policy_nonce_directives = %w[script-src]

Rails.application.config.content_security_policy_report_only = false
