# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: true
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/ruby-vips/all/ruby-vips.rbi
#
# ruby-vips-2.2.4

module GObject
  extend FFI::Library
end
class GObject::GObject
  extend Forwardable
  extend SingleForwardable
end
module GObject::GObject::GObjectLayout
end
class GObject::GObject::ManagedStruct < FFI::ManagedStruct
  include GObject::GObject::GObjectLayout
end
class GObject::GObject::Struct < FFI::Struct
  include GObject::GObject::GObjectLayout
end
class GObject::GParamSpec < FFI::Struct
end
class GObject::GParamSpecPtr < FFI::Struct
end
class GObject::GValue < FFI::ManagedStruct
end
module Vips
  extend FFI::Library
end
class Vips::Progress < FFI::Struct
end
class Vips::SizeStruct < FFI::Struct
end
class Vips::IntStruct < FFI::Struct
end
class Vips::Object < GObject::GObject
end
module Vips::Object::ObjectLayout
end
class Vips::Object::Struct < GObject::GObject::Struct
  include Vips::Object::ObjectLayout
end
class Vips::Object::ManagedStruct < GObject::GObject::ManagedStruct
  include Vips::Object::ObjectLayout
end
class Vips::ObjectClass < FFI::Struct
end
class Vips::Argument < FFI::Struct
end
class Vips::ArgumentInstance < Vips::Argument
end
class Vips::ArgumentClass < Vips::Argument
end
class Vips::ArgumentClassPtr < FFI::Struct
end
class Vips::ArgumentInstancePtr < FFI::Struct
end
class Vips::Introspect
end
class Vips::Operation < Vips::Object
end
module Vips::Operation::OperationLayout
end
class Vips::Operation::Struct < Vips::Object::Struct
  include Vips::Operation::OperationLayout
end
class Vips::Operation::ManagedStruct < Vips::Object::ManagedStruct
  include Vips::Operation::OperationLayout
end
class Vips::Image < Vips::Object
end
module Vips::Image::ImageLayout
end
class Vips::Image::Struct < Vips::Object::Struct
  include Vips::Image::ImageLayout
end
class Vips::Image::ManagedStruct < Vips::Object::ManagedStruct
  include Vips::Image::ImageLayout
end
class Vips::Image::GenericPtr < FFI::Struct
end
module Vips::Yard
end
class Vips::MutableImage < Vips::Object
  extend Forwardable
end
module Vips::MutableImage::MutableImageLayout
end
class Vips::MutableImage::Struct < Vips::Object::Struct
  include Vips::MutableImage::MutableImageLayout
end
class Vips::MutableImage::ManagedStruct < Vips::Object::ManagedStruct
  include Vips::MutableImage::MutableImageLayout
end
class Vips::Interpolate < Vips::Object
end
module Vips::Interpolate::InterpolateLayout
end
class Vips::Interpolate::Struct < Vips::Object::Struct
  include Vips::Interpolate::InterpolateLayout
end
class Vips::Interpolate::ManagedStruct < Vips::Object::ManagedStruct
  include Vips::Interpolate::InterpolateLayout
end
class Vips::Region < Vips::Object
end
module Vips::Region::RegionLayout
end
class Vips::Region::Struct < Vips::Object::Struct
  include Vips::Region::RegionLayout
end
class Vips::Region::ManagedStruct < Vips::Object::ManagedStruct
  include Vips::Region::RegionLayout
end
class Vips::Connection < Vips::Object
end
module Vips::Connection::ConnectionLayout
end
class Vips::Connection::Struct < Vips::Object::Struct
  include Vips::Connection::ConnectionLayout
end
class Vips::Connection::ManagedStruct < Vips::Object::ManagedStruct
  include Vips::Connection::ConnectionLayout
end
class Vips::Source < Vips::Connection
end
module Vips::Source::SourceLayout
end
class Vips::Source::Struct < Vips::Connection::Struct
  include Vips::Source::SourceLayout
end
class Vips::Source::ManagedStruct < Vips::Connection::ManagedStruct
  include Vips::Source::SourceLayout
end
class Vips::SourceCustom < Vips::Source
end
module Vips::SourceCustom::SourceCustomLayout
end
class Vips::SourceCustom::Struct < Vips::Source::Struct
  include Vips::SourceCustom::SourceCustomLayout
end
class Vips::SourceCustom::ManagedStruct < Vips::Source::ManagedStruct
  include Vips::SourceCustom::SourceCustomLayout
end
class Vips::Target < Vips::Connection
end
module Vips::Target::TargetLayout
end
class Vips::Target::Struct < Vips::Connection::Struct
  include Vips::Target::TargetLayout
end
class Vips::Target::ManagedStruct < Vips::Connection::ManagedStruct
  include Vips::Target::TargetLayout
end
class Vips::TargetCustom < Vips::Target
end
module Vips::TargetCustom::TargetCustomLayout
end
class Vips::TargetCustom::Struct < Vips::Target::Struct
  include Vips::TargetCustom::TargetCustomLayout
end
class Vips::TargetCustom::ManagedStruct < Vips::Target::ManagedStruct
  include Vips::TargetCustom::TargetCustomLayout
end
module GLib
  extend FFI::Library
end
class Vips::Error < RuntimeError
end
