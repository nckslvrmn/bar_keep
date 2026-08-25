Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, :https, :data, :blob
  policy.object_src  :none
  policy.script_src  :self
  policy.style_src   :self, :unsafe_inline
  policy.connect_src :self

  if Rails.env.development?
    policy.script_src :self, :unsafe_eval, :unsafe_inline
  end
end

Rails.application.config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
Rails.application.config.content_security_policy_nonce_directives = %w[script-src]

Rails.application.config.content_security_policy_report_only = false
