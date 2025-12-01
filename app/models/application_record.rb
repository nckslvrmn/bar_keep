# typed: true

class ApplicationRecord < ActiveRecord::Base
  extend T::Sig

  primary_abstract_class
end
