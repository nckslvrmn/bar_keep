# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: true
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/fugit/all/fugit.rbi
#
# fugit-1.11.1

module Fugit
  def self.determine_type(s); end
  def self.do_parse(s, opts = nil); end
  def self.do_parse_at(s); end
  def self.do_parse_cron(s); end
  def self.do_parse_cronish(s, opts = nil); end
  def self.do_parse_duration(s); end
  def self.do_parse_in(s); end
  def self.do_parse_nat(s, opts = nil); end
  def self.isostamp(show_date, show_time, show_usec, time); end
  def self.parse(s, opts = nil); end
  def self.parse_at(s); end
  def self.parse_cron(s); end
  def self.parse_cronish(s, opts = nil); end
  def self.parse_duration(s); end
  def self.parse_in(s); end
  def self.parse_nat(s, opts = nil); end
  def self.time_to_plain_s(t = nil, z = nil); end
  def self.time_to_s(t); end
  def self.time_to_zone_s(t = nil); end
end
class Fugit::Cron
  def ==(o); end
  def brute_frequency(year = nil); end
  def compact_month_days; end
  def day_match?(nt); end
  def determine_hours(arr); end
  def determine_minutes(arr); end
  def determine_monthdays(arr); end
  def determine_months(arr); end
  def determine_seconds(arr); end
  def determine_timezone(z); end
  def determine_weekdays(arr); end
  def do_determine(key, arr, min, max); end
  def eql?(o); end
  def expand(min, max, r); end
  def hash; end
  def hour_match?(nt); end
  def hours; end
  def init(original, h); end
  def match?(t); end
  def min_match?(nt); end
  def minutes; end
  def month_match?(nt); end
  def monthday_match?(nt); end
  def monthdays; end
  def months; end
  def next(from = nil); end
  def next_time(from = nil); end
  def original; end
  def prev(from = nil); end
  def previous_time(from = nil); end
  def range(min, max, sta, edn, sla); end
  def rough_days; end
  def rough_frequency; end
  def sec_match?(nt); end
  def seconds; end
  def self.do_parse(s); end
  def self.new(original); end
  def self.parse(s); end
  def self.trunc(s); end
  def timezone; end
  def to_a; end
  def to_cron_s; end
  def to_h; end
  def weekday_hash_match?(nt, hsh); end
  def weekday_match?(nt); end
  def weekday_modulo_match?(nt, mod); end
  def weekdays; end
  def weekdays_to_cron_s; end
  def within(time_range, time_end = nil); end
  def zone; end
end
class Fugit::Cron::TimeCursor
  def day; end
  def dec(i); end
  def dec_day; end
  def dec_hour; end
  def dec_min; end
  def dec_month; end
  def dec_sec; end
  def hour; end
  def inc(i); end
  def inc_day; end
  def inc_hour; end
  def inc_min; end
  def inc_month; end
  def inc_sec; end
  def initialize(cron, t); end
  def min; end
  def month; end
  def rday; end
  def rweek; end
  def sec; end
  def time; end
  def to_i; end
  def to_t; end
  def wday; end
  def wday_in_month; end
  def year; end
end
class Fugit::Cron::CronIterator
  def cron; end
  def current; end
  def direction; end
  def each; end
  def initialize(cron, direction, start); end
  def start; end
  include Enumerable
end
class Fugit::Cron::Frequency
  def delta_max; end
  def delta_min; end
  def initialize(deltas, span); end
  def occurrences; end
  def span; end
  def span_years; end
  def to_debug_s; end
  def yearly_occurrences; end
end
module Fugit::Cron::Parser
  extend Fugit::Cron::Parser
  extend Raabro::ModuleMethods
  include Raabro
end
class Fugit::Duration
  def +(a); end
  def -(a); end
  def -@; end
  def ==(o); end
  def _to_s(key); end
  def add(a); end
  def add_duration(d); end
  def add_numeric(n); end
  def add_to_time(t); end
  def deflate(options = nil); end
  def drop_seconds; end
  def eql?(o); end
  def h; end
  def hash; end
  def inflate; end
  def init(original, options, h); end
  def next_time(from = nil); end
  def opposite; end
  def options; end
  def original; end
  def self.common_rewrite_dur(t); end
  def self.do_parse(s, opts = nil); end
  def self.new(s); end
  def self.parse(s, opts = nil); end
  def self.to_iso_s(o); end
  def self.to_long_s(o, opts = nil); end
  def self.to_plain_s(o); end
  def subtract(a); end
  def to_h; end
  def to_iso_s; end
  def to_long_s(opts = nil); end
  def to_plain_s; end
  def to_rufus_h; end
  def to_rufus_s; end
  def to_sec; end
end
module Fugit::Duration::Parser
  extend Fugit::Duration::Parser
  extend Raabro::ModuleMethods
  include Raabro
end
module Fugit::Duration::IsoParser
  extend Fugit::Duration::IsoParser
  extend Raabro::ModuleMethods
  include Raabro
end
module Fugit::Nat
  def self.do_parse(s, opts = nil); end
  def self.parse(s, opts = nil); end
end
module Fugit::Nat::Parser
  extend Fugit::Nat::Parser
  extend Raabro::ModuleMethods
  include Raabro
end
class Fugit::Nat::Slot
  def _data0; end
  def _data0=(arg0); end
  def _data1; end
  def _data1=(arg0); end
  def a; end
  def append(slot); end
  def conflate(index, slot); end
  def data0; end
  def data1; end
  def graded?; end
  def hour_range; end
  def initialize(key, d0, d1 = nil, opts = nil); end
  def inspect; end
  def key; end
  def strong; end
  def to_a(x); end
  def weak; end
end
class Fugit::Nat::SlotGroup
  def determine_hms; end
  def initialize(slots); end
  def make_slot(key, data0, data1 = nil); end
  def parse_cron(hm, opts); end
  def restrict(a, cron); end
  def slot(key, default); end
  def to_crons(opts); end
end
module Fugit::At
  def self.do_parse(s); end
  def self.parse(s); end
end
