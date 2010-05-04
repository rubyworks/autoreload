#!/usr/bin/env ruby

require 'rubygems'
require 'redcloth'
require 'syntax/convertors/html'
require 'erb'

class Fixnum
  def ordinal
    # teens
    return 'th' if (10..19).include?(self % 100)
    # others
    case self % 10
    when 1: return 'st'
    when 2: return 'nd'
    when 3: return 'rd'
    else    return 'th'
    end
  end
end

class Time
  def pretty
    return "#{mday}#{mday.ordinal} #{strftime('%B')} #{year}"
  end
end

class Txt2Html
  def self.main(argv)
    self.new.main(argv)
  end

  DEFAULT_TEMPLATE = File.dirname(__FILE__) + '/../website/template.rhtml'

  def main(argv)
    if argv.length >= 1
      src, template = argv
      template ||= DEFAULT_TEMPLATE
    else
      puts("Usage: #{File.split($0).last} source.txt [template.rhtml] > output.html")
      exit!
    end

    version  = VERS
    download = DOWNLOAD_PATH
    result = generate2(template, src, version, download)
    $stdout << result
  end

  def translate(src, dest, version, download)
    template = DEFAULT_TEMPLATE
    result = generate2(template, src, version, download)
    File.open(dest, 'wb') {|f| f.print result }
  end

  def generate2(template, src, version, download)
    template_text = File.open(template).read
    src_text = File.open(src) {|fsrc| fsrc.read }
    modified = File.stat(src).mtime
    result = generate(template_text, src_text, modified, version, download)
  end

  def generate(template_text, src_text, modified, version, download)
    title_text, body_text = parse_title_body(src_text)
    title = create_title(title_text)
    body = create_body(body_text)
    template = ERB.new(template_text)
    result = template.result(binding)
    return result
  end

  def parse_title_body(str)
    /\A(.*?)\n(.*)/m =~ str
    return $1, $2
  end

  def create_title(title_text)
    return RedCloth.new(title_text).to_html.gsub(%r!<.*?>!,'').strip
  end

  def create_body(body_text)
    syntax_items = []
    body_text.gsub!(%r!<(pre|code)[^>]*?syntax=['"]([^'"]+)[^>]*>(.*?)</>!m) {
      ident = syntax_items.length
      element, syntax, source = $1, $2, $3
      syntax_items << "<#{element} class='syntax'>#{convert_syntax(syntax, source)}</#{element}>"
      "syntax-temp-#{ident}"
    }
    body = RedCloth.new(body_text).to_html
    body.gsub!(%r!(?:<pre><code>)?syntax-temp-(d+)(?:</code></pre>)?!){ syntax_items[$1.to_i] }
    return body
  end

  def convert_syntax(syntax, source)
    return Syntax::Convertors::HTML.for_syntax(syntax).convert(source).gsub(%r!^<pre>|</pre>$!, '')
  end
end

if $0 == __FILE__
  require "test/unit"
  $__test_txt2html__ = true
end

if defined?($__test_txt2html__) && $__test_txt2html__
  class TestTxt2Html < Test::Unit::TestCase #:nodoc:
    def test_fixnum_ordinal
      assert_equal 'st', 1.ordinal
    end

    def test_time_pretty
      assert_equal '1st January 1970', Time.at(0).pretty
    end

    def test_all
      # test_txt2html
      t2h = Txt2Html.new

      # test_parse_title_body
      assert_equal ["title", "body\n"], t2h.parse_title_body("title\nbody\n")
      assert_equal ["title", "b\nb\n"], t2h.parse_title_body("title\nb\nb\n")

      # test_create_title
      assert_equal 'title', t2h.create_title('h1. title')

      # test_create_body
      assert_equal '<h2>body</h2>', t2h.create_body('h2. body')

      # test_convert_syntax
      assert_equal '<span class="number">0</span>',
	t2h.convert_syntax('ruby', '0')
    end
  end
end
