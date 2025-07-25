# typed: false

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `mini_magick` gem.
# Please instead update this file by running `bin/tapioca gem mini_magick`.


# source://mini_magick//lib/mini_magick/version.rb#1
module MiniMagick
  extend ::MiniMagick::Configuration

  class << self
    # source://mini_magick//lib/mini_magick.rb#26
    def animate(**options, &block); end

    # Returns ImageMagick version.
    #
    # @return [String]
    #
    # source://mini_magick//lib/mini_magick.rb#36
    def cli_version; end

    # source://mini_magick//lib/mini_magick.rb#26
    def compare(**options, &block); end

    # source://mini_magick//lib/mini_magick.rb#26
    def composite(**options, &block); end

    # source://mini_magick//lib/mini_magick.rb#26
    def conjure(**options, &block); end

    # source://mini_magick//lib/mini_magick.rb#26
    def convert(**options, &block); end

    # source://mini_magick//lib/mini_magick.rb#26
    def display(**options, &block); end

    # source://mini_magick//lib/mini_magick.rb#26
    def identify(**options, &block); end

    # Checks whether ImageMagick 7 is installed.
    #
    # @return [Boolean]
    #
    # source://mini_magick//lib/mini_magick.rb#19
    def imagemagick7?; end

    # source://mini_magick//lib/mini_magick.rb#26
    def import(**options, &block); end

    # source://mini_magick//lib/mini_magick.rb#26
    def mogrify(**options, &block); end

    # source://mini_magick//lib/mini_magick.rb#26
    def montage(**options, &block); end

    # source://mini_magick//lib/mini_magick.rb#26
    def stream(**options, &block); end

    # @return [Gem::Version]
    #
    # source://mini_magick//lib/mini_magick/version.rb#5
    def version; end
  end
end

# source://mini_magick//lib/mini_magick/configuration.rb#5
module MiniMagick::Configuration
  # Adds environment variables to every CLI command call.
  # For example, you could use it to set `LD_PRELOAD="/path/to/libsomething.so"`.
  # Must be a hash of strings keyed to valid environment variable name strings.
  # e.g. {'MY_ENV' => 'my value'}
  #
  # @return [Hash]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#33
  def cli_env; end

  # Adds environment variables to every CLI command call.
  # For example, you could use it to set `LD_PRELOAD="/path/to/libsomething.so"`.
  # Must be a hash of strings keyed to valid environment variable name strings.
  # e.g. {'MY_ENV' => 'my value'}
  #
  # @return [Hash]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#33
  def cli_env=(_arg0); end

  # Adds a prefix to the CLI command.
  # For example, you could use `firejail` to run all commands in a sandbox.
  # Can be a string, or an array of strings.
  # e.g. 'firejail', or ['firejail', '--force']
  #
  # @return [String]
  # @return [Array<String>]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#23
  def cli_prefix; end

  # Adds a prefix to the CLI command.
  # For example, you could use `firejail` to run all commands in a sandbox.
  # Can be a string, or an array of strings.
  # e.g. 'firejail', or ['firejail', '--force']
  #
  # @return [String]
  # @return [Array<String>]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#23
  def cli_prefix=(_arg0); end

  # @example
  #   MiniMagick.configure do |config|
  #   config.timeout = 5
  #   end
  # @yield [self]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#97
  def configure; end

  # If set to `false`, it will not raise errors when ImageMagick returns
  # status code different than 0. Defaults to `true`.
  #
  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#73
  def errors; end

  # If set to `false`, it will not raise errors when ImageMagick returns
  # status code different than 0. Defaults to `true`.
  #
  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#73
  def errors=(_arg0); end

  # Uses [GraphicsMagick](http://www.graphicsmagick.org/) instead of
  # ImageMagick, by prefixing commands with `gm` instead of `magick`.
  #
  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#12
  def graphicsmagick; end

  # Uses [GraphicsMagick](http://www.graphicsmagick.org/) instead of
  # ImageMagick, by prefixing commands with `gm` instead of `magick`.
  #
  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#12
  def graphicsmagick=(_arg0); end

  # Logger for commands, default is `Logger.new($stdout)`, but you can
  # override it, for example if you want the logs to be written to a file.
  #
  # @return [Logger]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#58
  def logger; end

  # Logger for commands, default is `Logger.new($stdout)`, but you can
  # override it, for example if you want the logs to be written to a file.
  #
  # @return [Logger]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#58
  def logger=(_arg0); end

  # If set to true, Open3 will restrict system calls to access only
  # environment variables defined in :cli_env, plus HOME, PATH, and LANG
  # since those are required for such system calls. It will not pass on any
  # other environment variables from the system.
  #
  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#43
  def restricted_env; end

  # If set to true, Open3 will restrict system calls to access only
  # environment variables defined in :cli_env, plus HOME, PATH, and LANG
  # since those are required for such system calls. It will not pass on any
  # other environment variables from the system.
  #
  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#43
  def restricted_env=(_arg0); end

  # If you don't want commands to take too long, you can set a timeout (in
  # seconds).
  #
  # @return [Integer]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#51
  def timeout; end

  # If you don't want commands to take too long, you can set a timeout (in
  # seconds).
  #
  # @return [Integer]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#51
  def timeout=(_arg0); end

  # Temporary directory used by MiniMagick, default is `Dir.tmpdir`, but
  # you can override it.
  #
  # @return [String]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#65
  def tmpdir; end

  # Temporary directory used by MiniMagick, default is `Dir.tmpdir`, but
  # you can override it.
  #
  # @return [String]
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#65
  def tmpdir=(_arg0); end

  # If set to `false`, it will not forward warnings from ImageMagick to
  # standard error.
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#78
  def warnings; end

  # If set to `false`, it will not forward warnings from ImageMagick to
  # standard error.
  #
  # source://mini_magick//lib/mini_magick/configuration.rb#78
  def warnings=(_arg0); end

  class << self
    # @private
    #
    # source://mini_magick//lib/mini_magick/configuration.rb#80
    def extended(base); end
  end
end

# source://mini_magick//lib/mini_magick.rb#9
class MiniMagick::Error < ::RuntimeError; end

# source://mini_magick//lib/mini_magick/image/info.rb#4
class MiniMagick::Image
  # Create a new {MiniMagick::Image} object.
  #
  # _DANGER_: The file location passed in here is the *working copy*. That
  # is, it gets *modified*. You can either copy it yourself or use {.open}
  # which creates a temporary file for you and protects your original.
  #
  # @param input_path [String, Pathname] The location of an image file
  # @return [Image] a new instance of Image
  # @yield [MiniMagick::Tool] If block is given, {#combine_options}
  #   is called.
  #
  # source://mini_magick//lib/mini_magick/image.rb#148
  def initialize(input_path, tempfile = T.unsafe(nil), &block); end

  # source://mini_magick//lib/mini_magick/image.rb#156
  def ==(other); end

  # Use this method if you want to access raw Identify's format API.
  #
  # @example
  #   image["%w %h"]       #=> "250 450"
  #   image["%r"]          #=> "DirectClass sRGB"
  # @param value [String]
  # @return [String]
  # @see http://www.imagemagick.org/script/escape.php
  #
  # source://mini_magick//lib/mini_magick/image.rb#279
  def [](value); end

  # Collapse images with sequences to the first frame (i.e. animated gifs) and
  # preserve quality.
  #
  # @param frame [Integer] The frame to which to collapse to, defaults to `0`.
  # @return [self]
  #
  # source://mini_magick//lib/mini_magick/image.rb#532
  def collapse!(frame = T.unsafe(nil)); end

  # @return [String]
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def colorspace(*args); end

  # You can use multiple commands together using this method. Very easy to
  # use!
  #
  # @example
  #   image.combine_options do |c|
  #   c.draw "image Over 0,0 10,10 '#{MINUS_IMAGE_PATH}'"
  #   c.thumbnail "300x500>"
  #   c.background "blue"
  #   end
  # @return [self]
  # @see http://www.imagemagick.org/script/mogrify.php
  # @yield [MiniMagick::Command]
  #
  # source://mini_magick//lib/mini_magick/image.rb#451
  def combine_options(&block); end

  # @example
  #   first_image = MiniMagick::Image.open "first.jpg"
  #   second_image = MiniMagick::Image.open "second.jpg"
  #   result = first_image.composite(second_image) do |c|
  #   c.compose "Over" # OverCompositeOp
  #   c.geometry "+20+20" # copy second_image onto first_image from (20, 20)
  #   end
  #   result.write "output.jpg"
  # @see http://www.imagemagick.org/script/composite.php
  #
  # source://mini_magick//lib/mini_magick/image.rb#511
  def composite(other_image, output_extension = T.unsafe(nil), mask = T.unsafe(nil)); end

  # Returns the result of converting the image to JSON format.
  #
  # @return [Hash]
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def data(*args); end

  # Destroys the tempfile (created by {.open}) if it exists.
  #
  # source://mini_magick//lib/mini_magick/image.rb#539
  def destroy!; end

  # @return [Array<Integer>]
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def dimensions(*args); end

  # source://mini_magick//lib/mini_magick/image.rb#159
  def eql?(other); end

  # @return [Hash]
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def exif(*args); end

  # This is used to change the format of the image. That is, from "tiff to
  # jpg" or something like that. Once you run it, the instance is pointing to
  # a new file with a new extension!
  #
  # *DANGER*: This renames the file that the instance is pointing to. So, if
  # you manually opened the file with Image.new(file_path)... Then that file
  # is DELETED! If you used Image.open(file) then you are OK. The original
  # file will still be there. But, any changes to it might not be...
  #
  # Formatting an animation into a non-animated type will result in
  # ImageMagick creating multiple pages (starting with 0).  You can choose
  # which page you want to manipulate.  We default to the first page.
  #
  # If you would like to convert between animated formats, pass nil as your
  # page and ImageMagick will copy all of the pages.
  #
  # @param format [String] The target format... Like 'jpg', 'gif', 'tiff' etc.
  # @param page [Integer] If this is an animated gif, say which 'page' you
  #   want with an integer. Default 0 will convert only the first page; 'nil'
  #   will convert all pages.
  # @param read_opts [Hash] Any read options to be passed to ImageMagick
  #   for example: image.format('jpg', page, {density: '300'})
  # @return [self]
  # @yield [MiniMagick::Tool] It optionally yields the command,
  #   if you want to add something.
  #
  # source://mini_magick//lib/mini_magick/image.rb#400
  def format(format, page = T.unsafe(nil), read_opts = T.unsafe(nil)); end

  # Returns layers of the image. For example, JPEGs are 1-layered, but
  # formats like PSDs, GIFs and PDFs can have multiple layers/frames/pages.
  #
  # @example
  #   image = MiniMagick::Image.new("document.pdf")
  #   image.pages.each_with_index do |page, idx|
  #   page.write("page#{idx}.pdf")
  #   end
  # @return [Array<MiniMagick::Image>]
  #
  # source://mini_magick//lib/mini_magick/image.rb#302
  def frames; end

  # Returns a matrix of pixels from the image. The matrix is constructed as
  # an array (1) of arrays (2) of arrays (3) of unsigned integers:
  #
  # 1) one for each row of pixels
  # 2) one for each column of pixels
  # 3) three or four elements in the range 0-255, one for each of the RGB(A) color channels
  #
  # It can also be called after applying transformations:
  #
  # In this example, all pixels in pix should now have equal R, G, and B values.
  #
  # @example
  #   img = MiniMagick::Image.open 'image.jpg'
  #   pixels = img.get_pixels
  #   pixels[3][2][1] # the green channel value from the 4th-row, 3rd-column pixel
  # @example
  #   img = MiniMagick::Image.open 'image.jpg'
  #   pixels = img.get_pixels("RGBA")
  #   pixels[3][2][3] # the alpha channel value from the 4th-row, 3rd-column pixel
  # @example
  #   img = MiniMagick::Image.open 'image.jpg'
  #   img.crop '20x30+10+5'
  #   img.colorspace 'Gray'
  #   pixels = img.get_pixels
  # @param map [String] A code for the mapping of the pixel data. Must be either
  #   'RGB' or 'RGBA'. Default to 'RGB'
  # @raise [ArgumentError]
  # @return [Array] Matrix of each color of each pixel
  #
  # source://mini_magick//lib/mini_magick/image.rb#335
  def get_pixels(map = T.unsafe(nil)); end

  # source://mini_magick//lib/mini_magick/image.rb#161
  def hash; end

  # @return [Integer]
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def height(*args); end

  # Returns the file size in a human readable format.
  #
  # @return [String]
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def human_size(*args); end

  # Runs `identify` on itself. Accepts an optional block for adding more
  # options to `identify`.
  #
  # @example
  #   image = MiniMagick::Image.open("image.jpg")
  #   image.identify do |b|
  #   b.verbose
  #   end # runs `identify -verbose image.jpg`
  # @return [String] Output from `identify`
  # @yield [MiniMagick::Tool]
  #
  # source://mini_magick//lib/mini_magick/image.rb#558
  def identify; end

  # Use this method if you want to access raw Identify's format API.
  #
  # @example
  #   image["%w %h"]       #=> "250 450"
  #   image["%r"]          #=> "DirectClass sRGB"
  # @param value [String]
  # @return [String]
  # @see http://www.imagemagick.org/script/escape.php
  #
  # source://mini_magick//lib/mini_magick/image.rb#282
  def info(value); end

  # Compares if image width
  # is greater than height
  # ============
  # ============
  #
  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/image.rb#591
  def landscape?; end

  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/image.rb#579
  def layer?; end

  # Returns layers of the image. For example, JPEGs are 1-layered, but
  # formats like PSDs, GIFs and PDFs can have multiple layers/frames/pages.
  #
  # @example
  #   image = MiniMagick::Image.new("document.pdf")
  #   image.pages.each_with_index do |page, idx|
  #   page.write("page#{idx}.pdf")
  #   end
  # @return [Array<MiniMagick::Image>]
  #
  # source://mini_magick//lib/mini_magick/image.rb#295
  def layers; end

  # If an unknown method is called then it is sent through the mogrify
  # program.
  #
  # @return [self]
  # @see http://www.imagemagick.org/script/mogrify.php
  #
  # source://mini_magick//lib/mini_magick/image.rb#462
  def method_missing(name, *args); end

  # source://mini_magick//lib/mini_magick/image.rb#565
  def mogrify(page = T.unsafe(nil)); end

  # Returns layers of the image. For example, JPEGs are 1-layered, but
  # formats like PSDs, GIFs and PDFs can have multiple layers/frames/pages.
  #
  # @example
  #   image = MiniMagick::Image.new("document.pdf")
  #   image.pages.each_with_index do |page, idx|
  #   page.write("page#{idx}.pdf")
  #   end
  # @return [Array<MiniMagick::Image>]
  #
  # source://mini_magick//lib/mini_magick/image.rb#301
  def pages; end

  # @return [String] The location of the current working file
  #
  # source://mini_magick//lib/mini_magick/image.rb#131
  def path; end

  # Compares if image height
  # is greater than width
  # ======
  # ======
  #
  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/image.rb#605
  def portrait?; end

  # Returns the resolution of the photo. You can optionally specify the
  # units measurement.
  #
  # @example
  #   image.resolution("PixelsPerInch") #=> [250, 250]
  # @return [Array<Integer>]
  # @see http://www.imagemagick.org/script/command-line-options.php#units
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def resolution(*args); end

  # Returns the message digest of this image as a SHA-256, hexadecimal
  # encoded string. This signature uniquely identifies the image and is
  # convenient for determining if an image has been modified or whether two
  # images are identical.
  #
  # @example
  #   image.signature #=> "60a7848c4ca6e36b8e2c5dea632ecdc29e9637791d2c59ebf7a54c0c6a74ef7e"
  # @return [String]
  # @see http://www.imagemagick.org/api/signature.php
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def signature(*args); end

  # Returns the file size of the image (in bytes).
  #
  # @return [Integer]
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def size(*args); end

  # @return [Tempfile] The underlying temporary file
  #
  # source://mini_magick//lib/mini_magick/image.rb#135
  def tempfile; end

  # Returns raw image data.
  #
  # @return [String] Binary string
  #
  # source://mini_magick//lib/mini_magick/image.rb#170
  def to_blob; end

  # Returns the image format (e.g. "JPEG", "GIF").
  #
  # @return [String]
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def type(*args); end

  # Checks to make sure that MiniMagick can read the file and understand it.
  #
  # This uses the 'identify' command line utility to check the file. If you
  # are having issues with this, then please work directly with the
  # 'identify' command and see if you can figure out what the issue is.
  #
  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/image.rb#183
  def valid?; end

  # Runs `identify` on the current image, and raises an error if it doesn't
  # pass.
  #
  # @raise [MiniMagick::Invalid]
  #
  # source://mini_magick//lib/mini_magick/image.rb#196
  def validate!; end

  # @return [Integer]
  #
  # source://mini_magick//lib/mini_magick/image.rb#119
  def width(*args); end

  # Writes the temporary file out to either a file location (by passing in a
  # String) or by passing in a Stream that you can #write(chunk) to
  # repeatedly
  #
  # @param output_to [String, Pathname, #read] Some kind of stream object
  #   that needs to be read or a file path as a String
  #
  # source://mini_magick//lib/mini_magick/image.rb#483
  def write(output_to); end

  private

  # Prevents ruby from calling `#to_ary` on the image when checking if it's a
  # splattable data structure in certain cases.
  #
  # @return [Boolean]
  #
  # source://mini_magick//lib/mini_magick/image.rb#471
  def respond_to_missing?(name, include_all); end

  class << self
    # @private
    #
    # source://mini_magick//lib/mini_magick/image.rb#118
    def attribute(name, key = T.unsafe(nil)); end

    # Used to create a new Image object data-copy. Not used to "paint" or
    # that kind of thing.
    #
    # Takes an extension in a block and can be used to build a new Image
    # object. Used by both {.open} and {.read} to create a new object. Ensures
    # we have a good tempfile.
    #
    # @param ext [String] Specify the extension you want to read it as
    # @return [MiniMagick::Image] The created image
    # @yield [Tempfile] You can #write bits to this object to create the new
    #   Image
    #
    # source://mini_magick//lib/mini_magick/image.rb#107
    def create(ext = T.unsafe(nil), &block); end

    # This is used to create image from pixels. This might be required if you
    # create pixels for some image processing reasons and you want to form
    # image from those pixels.
    #
    # *DANGER*: This operation can be very expensive. Please try to use with
    # caution.
    #
    # @example
    #   # It is given in readme.md file
    #
    # source://mini_magick//lib/mini_magick/image.rb#367
    def get_image_from_pixels(pixels, dimension, map, depth, format); end

    # Creates an image object from a binary string blob which contains raw
    # pixel data (i.e. no header data).
    #
    # Defaults to 'png'.
    #
    # @param blob [String] Binary string blob containing raw pixel data.
    # @param columns [Integer] Number of columns.
    # @param rows [Integer] Number of rows.
    # @param depth [Integer] Bit depth of the encoded pixel data.
    # @param map [String] A code for the mapping of the pixel data. Example:
    #   'gray' or 'rgb'.
    # @param format [String] The file extension of the image format to be
    #   used when creating the image object.
    # @return [MiniMagick::Image] The loaded image.
    #
    # source://mini_magick//lib/mini_magick/image.rb#52
    def import_pixels(blob, columns, rows, depth, map, format = T.unsafe(nil)); end

    # Opens a specific image file either on the local file system or at a URI.
    # Use this if you don't want to overwrite the image file.
    #
    # Extension is either guessed from the path or you can specify it as a
    # second parameter.
    #
    # @param path_or_url [String] Either a local file path or a URL that
    #   open-uri can read
    # @param ext [String] Specify the extension you want to read it as
    # @param options [Hash] Specify options for the open method
    # @return [MiniMagick::Image] The loaded image
    #
    # source://mini_magick//lib/mini_magick/image.rb#82
    def open(path_or_url, ext = T.unsafe(nil), **options); end

    # This is the primary loading method used by all of the other class
    # methods.
    #
    # Use this to pass in a stream object. Must respond to #read(size) or be a
    # binary string object (BLOB)
    #
    # Probably easier to use the {.open} method if you want to open a file or a
    # URL.
    #
    # @param stream [#read, String] Some kind of stream object that needs
    #   to be read or is a binary String blob
    # @param ext [String] A manual extension to use for reading the file. Not
    #   required, but if you are having issues, give this a try.
    # @return [MiniMagick::Image]
    #
    # source://mini_magick//lib/mini_magick/image.rb#29
    def read(stream, ext = T.unsafe(nil)); end
  end
end

# @private
#
# source://mini_magick//lib/mini_magick/image/info.rb#6
class MiniMagick::Image::Info
  # @return [Info] a new instance of Info
  #
  # source://mini_magick//lib/mini_magick/image/info.rb#9
  def initialize(path); end

  # source://mini_magick//lib/mini_magick/image/info.rb#14
  def [](value, *args); end

  # source://mini_magick//lib/mini_magick/image/info.rb#39
  def cheap_info(value); end

  # source://mini_magick//lib/mini_magick/image/info.rb#35
  def clear; end

  # source://mini_magick//lib/mini_magick/image/info.rb#71
  def colorspace; end

  # source://mini_magick//lib/mini_magick/image/info.rb#116
  def data; end

  # source://mini_magick//lib/mini_magick/image/info.rb#87
  def exif; end

  # source://mini_magick//lib/mini_magick/image/info.rb#129
  def identify; end

  # @raise [TypeError]
  #
  # source://mini_magick//lib/mini_magick/image/info.rb#61
  def parse_warnings(raw_info); end

  # source://mini_magick//lib/mini_magick/image/info.rb#108
  def raw(value); end

  # source://mini_magick//lib/mini_magick/image/info.rb#83
  def raw_exif(value); end

  # source://mini_magick//lib/mini_magick/image/info.rb#75
  def resolution(unit = T.unsafe(nil)); end

  # source://mini_magick//lib/mini_magick/image/info.rb#112
  def signature; end

  private

  # source://mini_magick//lib/mini_magick/image/info.rb#138
  def decode_comma_separated_ascii_characters(encoded_value); end

  # source://mini_magick//lib/mini_magick/image/info.rb#143
  def path; end
end

# source://mini_magick//lib/mini_magick/image/info.rb#7
MiniMagick::Image::Info::ASCII_ENCODED_EXIF_KEYS = T.let(T.unsafe(nil), Array)

# source://mini_magick//lib/mini_magick.rb#10
class MiniMagick::Invalid < ::StandardError; end

# Sends commands to the shell (more precisely, it sends commands directly to
# the operating system).
#
# @private
#
# source://mini_magick//lib/mini_magick/shell.rb#10
class MiniMagick::Shell
  # source://mini_magick//lib/mini_magick/shell.rb#28
  def execute(command, stdin: T.unsafe(nil), timeout: T.unsafe(nil)); end

  # source://mini_magick//lib/mini_magick/shell.rb#12
  def run(command, errors: T.unsafe(nil), warnings: T.unsafe(nil), **options); end

  private

  # source://mini_magick//lib/mini_magick/shell.rb#44
  def log(command, &block); end
end

# source://mini_magick//lib/mini_magick.rb#11
class MiniMagick::TimeoutError < ::MiniMagick::Error; end

# Class that wraps command-line tools directly, as opposed MiniMagick::Image
# which is more high-level.
#
# @example
#   MiniMagick.mogrify do |mogrify|
#   mogrify.resize "500x500"
#   mogrify << "path/to/image.jpg"
#   end
#
# source://mini_magick//lib/mini_magick/tool.rb#14
class MiniMagick::Tool
  # @example
  #   MiniMagick.identify(errors: false) do |identify|
  #   identify.help # returns exit status 1, which would otherwise throw an error
  #   end
  # @option options
  # @option options
  # @option options
  # @param name [String]
  # @param options [Hash]
  # @return [Tool] a new instance of Tool
  #
  # source://mini_magick//lib/mini_magick/tool.rb#54
  def initialize(name, **options); end

  # Changes the last operator to its "plus" form.
  #
  # @example
  #   MiniMagick.mogrify do |mogrify|
  #   mogrify.antialias.+
  #   mogrify.distort.+("Perspective", "0,0,4,5 89,0,45,46")
  #   end
  #   # executes `mogrify +antialias +distort Perspective '0,0,4,5 89,0,45,46'`
  # @return [self]
  #
  # source://mini_magick//lib/mini_magick/tool.rb#162
  def +(*values); end

  # Appends raw options, useful for appending image paths.
  #
  # @return [self]
  #
  # source://mini_magick//lib/mini_magick/tool.rb#135
  def <<(arg); end

  # @private
  #
  # source://mini_magick//lib/mini_magick/tool.rb#42
  def args; end

  # Executes the command that has been built up.
  #
  # @example
  #   mogrify = MiniMagick.mogrify
  #   mogrify.resize("500x500")
  #   mogrify << "path/to/image.jpg"
  #   mogrify.call # executes `mogrify -resize 500x500 path/to/image.jpg`
  # @example
  #   mogrify = MiniMagick.mogrify
  #   # build the command
  #   mogrify.call do |stdout, stderr, status|
  #   # ...
  #   end
  # @return [String] Returns the output of the command
  # @yield [Array] Optionally yields stdout, stderr, and exit status
  #
  # source://mini_magick//lib/mini_magick/tool.rb#80
  def call(**options); end

  # source://mini_magick//lib/mini_magick/tool.rb#232
  def canvas(value = T.unsafe(nil)); end

  # This option is a valid ImageMagick option, but it's also a Ruby method,
  # so we need to override it so that it correctly acts as an option method.
  #
  # source://mini_magick//lib/mini_magick/tool.rb#242
  def clone(*args); end

  # The currently built-up command.
  #
  # @example
  #   mogrify = MiniMagick.mogrify
  #   mogrify.resize "500x500"
  #   mogrify.contrast
  #   mogrify.command #=> ["mogrify", "-resize", "500x500", "-contrast"]
  # @return [Array<String>]
  #
  # source://mini_magick//lib/mini_magick/tool.rb#102
  def command; end

  # The executable used for this tool. Respects
  # {MiniMagick::Configuration#cli_prefix}.
  #
  # @example
  #   identify = MiniMagick.identify
  #   identify.executable #=> ["magick", "identify"]
  # @example
  #   MiniMagick.configure do |config|
  #   config.cli_prefix = ['firejail', '--force']
  #   end
  #   identify = MiniMagick.identify
  #   identify.executable #=> ["firejail", "--force", "magick", "identify"]
  # @return [Array<String>]
  #
  # source://mini_magick//lib/mini_magick/tool.rb#123
  def executable; end

  # source://mini_magick//lib/mini_magick/tool.rb#232
  def gradient(value = T.unsafe(nil)); end

  # source://mini_magick//lib/mini_magick/tool.rb#232
  def logo(value = T.unsafe(nil)); end

  # Merges a list of raw options.
  #
  # @return [self]
  #
  # source://mini_magick//lib/mini_magick/tool.rb#145
  def merge!(new_args); end

  # Any undefined method will be transformed into a CLI option
  #
  # @example
  #   mogrify = MiniMagick::Tool.new("mogrify")
  #   mogrify.adaptive_blur("...")
  #   mogrify.foo_bar
  #   mogrify.command.join(" ") # => "mogrify -adaptive-blur ... -foo-bar"
  #
  # source://mini_magick//lib/mini_magick/tool.rb#257
  def method_missing(name, *args); end

  # @private
  #
  # source://mini_magick//lib/mini_magick/tool.rb#42
  def name; end

  # source://mini_magick//lib/mini_magick/tool.rb#232
  def pango(value = T.unsafe(nil)); end

  # source://mini_magick//lib/mini_magick/tool.rb#232
  def pattern(value = T.unsafe(nil)); end

  # source://mini_magick//lib/mini_magick/tool.rb#232
  def plasma(value = T.unsafe(nil)); end

  # source://mini_magick//lib/mini_magick/tool.rb#232
  def radial_gradient(value = T.unsafe(nil)); end

  # source://mini_magick//lib/mini_magick/tool.rb#232
  def rose(value = T.unsafe(nil)); end

  # Create an ImageMagick stack in the command (surround.
  #
  # @example
  #   MiniMagick.convert do |convert|
  #   convert << "wand.gif"
  #   convert.stack do |stack|
  #   stack << "wand.gif"
  #   stack.rotate(30)
  #   end
  #   convert.append.+
  #   convert << "images.gif"
  #   end
  #   # executes `convert wand.gif \( wizard.gif -rotate 30 \) +append images.gif`
  # @yield [_self]
  # @yieldparam _self [MiniMagick::Tool] the object that the method was called on
  #
  # source://mini_magick//lib/mini_magick/tool.rb#183
  def stack(*args); end

  # Adds ImageMagick's pseudo-filename `-` for standard input.
  #
  # @example
  #   identify = MiniMagick.identify
  #   identify.stdin
  #   identify.call(stdin: image_content)
  #   # executes `identify -` with the given standard input
  #
  # source://mini_magick//lib/mini_magick/tool.rb#204
  def stdin; end

  # Adds ImageMagick's pseudo-filename `-` for standard output.
  #
  # @example
  #   content = MiniMagick.convert do |convert|
  #   convert << "input.jpg"
  #   convert.auto_orient
  #   convert.stdout
  #   end
  #   # executes `convert input.jpg -auto-orient -` which returns file contents
  #
  # source://mini_magick//lib/mini_magick/tool.rb#219
  def stdout; end

  # source://mini_magick//lib/mini_magick/tool.rb#232
  def text(value = T.unsafe(nil)); end

  # source://mini_magick//lib/mini_magick/tool.rb#232
  def xc(value = T.unsafe(nil)); end

  class << self
    # Aside from classic instantiation, it also accepts a block, and then
    # executes the command in the end.
    #
    # @example
    #   puts MiniMagick.identify(&:version)
    # @return [MiniMagick::Tool, String] If no block is given, returns an
    #   instance of the tool, if block is given, returns the output of the
    #   command.
    #
    # source://mini_magick//lib/mini_magick/tool.rb#30
    def new(name, **options); end
  end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Animate < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#16
MiniMagick::Tool::CREATION_OPERATORS = T.let(T.unsafe(nil), Array)

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Compare < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Composite < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Conjure < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Convert < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Display < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Identify < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Import < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Magick < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Mogrify < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Montage < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# source://mini_magick//lib/mini_magick/tool.rb#266
class MiniMagick::Tool::Stream < ::MiniMagick::Tool
  # source://mini_magick//lib/mini_magick/tool.rb#267
  def initialize(*args); end
end

# @private
#
# source://mini_magick//lib/mini_magick/utilities.rb#5
module MiniMagick::Utilities
  private

  # source://mini_magick//lib/mini_magick/utilities.rb#26
  def tempfile(extension); end

  # Cross-platform way of finding an executable in the $PATH.
  #
  # @example
  #   MiniMagick::Utilities.which('ruby') #=> "/usr/bin/ruby"
  #
  # source://mini_magick//lib/mini_magick/utilities.rb#15
  def which(cmd); end

  class << self
    # @yield [tempfile]
    #
    # source://mini_magick//lib/mini_magick/utilities.rb#26
    def tempfile(extension); end

    # Cross-platform way of finding an executable in the $PATH.
    #
    # @example
    #   MiniMagick::Utilities.which('ruby') #=> "/usr/bin/ruby"
    #
    # source://mini_magick//lib/mini_magick/utilities.rb#15
    def which(cmd); end
  end
end

# source://mini_magick//lib/mini_magick/version.rb#9
module MiniMagick::VERSION; end

# source://mini_magick//lib/mini_magick/version.rb#10
MiniMagick::VERSION::MAJOR = T.let(T.unsafe(nil), Integer)

# source://mini_magick//lib/mini_magick/version.rb#11
MiniMagick::VERSION::MINOR = T.let(T.unsafe(nil), Integer)

# source://mini_magick//lib/mini_magick/version.rb#13
MiniMagick::VERSION::PRE = T.let(T.unsafe(nil), T.untyped)

# source://mini_magick//lib/mini_magick/version.rb#15
MiniMagick::VERSION::STRING = T.let(T.unsafe(nil), String)

# source://mini_magick//lib/mini_magick/version.rb#12
MiniMagick::VERSION::TINY = T.let(T.unsafe(nil), Integer)
