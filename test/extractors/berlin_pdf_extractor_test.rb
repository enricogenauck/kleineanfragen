require 'test_helper'

class BerlinPDFExtractorTest < ActiveSupport::TestCase
  # testcases:
  PREFIX_DOT = "\n.................................\n"
  PREFIX_LINE = "\n_____________________________\n"
  SUFFIX = "\n \n \n (Eingang beim Abgeordnetenhaus"

  test 'normal ministry' do
    paper = Struct.new(:contents).new(
      PREFIX_DOT + 'Senatsverwaltung für Stadtentwicklung und Umwelt' + SUFFIX)

    answerers = BerlinPDFExtractor.new(paper).extract_answerers

    assert_equal 1, answerers[:ministries].size
    assert_equal 'Senatsverwaltung für Stadtentwicklung und Umwelt', answerers[:ministries].first
  end

  test 'normal ministry with leading newline' do
    paper = Struct.new(:contents).new(
      PREFIX_DOT + "\nSenatsverwaltung für Stadtentwicklung und Umwelt" + SUFFIX)

    answerers = BerlinPDFExtractor.new(paper).extract_answerers

    assert_equal 1, answerers[:ministries].size
    assert_equal 'Senatsverwaltung für Stadtentwicklung und Umwelt', answerers[:ministries].first
  end

  test 'normal ministry with newlines' do
    paper = Struct.new(:contents).new(
      PREFIX_DOT + "Senatsverwaltung für\n\nStadtentwicklung und Umwelt" + SUFFIX)

    answerers = BerlinPDFExtractor.new(paper).extract_answerers

    assert_equal 1, answerers[:ministries].size
    assert_equal 'Senatsverwaltung für Stadtentwicklung und Umwelt', answerers[:ministries].first
  end

  test 'normal ministry with newlines and spaces' do
    paper = Struct.new(:contents).new(
      PREFIX_DOT + "Senatsverwaltung für \n  \n Stadtentwicklung und Umwelt" + SUFFIX)

    answerers = BerlinPDFExtractor.new(paper).extract_answerers

    assert_equal 1, answerers[:ministries].size
    assert_equal 'Senatsverwaltung für Stadtentwicklung und Umwelt', answerers[:ministries].first
  end

  test 'lined ministry with newlines and spaces' do
    paper = Struct.new(:contents).new(
      PREFIX_LINE + "Senatsverwaltung für \n  \nGesundheit und Soziales " + SUFFIX)

    answerers = BerlinPDFExtractor.new(paper).extract_answerers

    assert_equal 1, answerers[:ministries].size
    assert_equal 'Senatsverwaltung für Gesundheit und Soziales', answerers[:ministries].first
  end
end