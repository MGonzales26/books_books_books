require 'minitest/autorun'
require 'minitest/pride'
require './lib/book'
require './lib/author'
require './lib/library'

class LibraryTest < Minitest::Test

  def test_it_exists
    dpl = Library.new("Denver Public Library") 

    assert_instance_of Library, dpl
  end

  def test_it_has_attributes
    dpl = Library.new("Denver Public Library") 

    assert_equal "Denver Public Library", dpl.name
    assert_equal [], dpl.books
    assert_equal [], dpl.authors
  end

  def test_it_can_add_authors_and_books
    dpl = Library.new("Denver Public Library") 

    charlotte_bronte = Author.new({first_name: "Charlotte", 
                                   last_name: "Bronte"})
    harper_lee = Author.new({first_name: "Harper", 
                             last_name: "Lee"})    

    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")  
    professor = charlotte_bronte.write("The Professor", "1857")
    villette = charlotte_bronte.write("Villette", "1853") 
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee)

    expected_authors = [charlotte_bronte, harper_lee]
    expected_books = [jane_eyre, professor, villette, mockingbird]

    assert_equal expected_authors, dpl.authors
    assert_equal expected_books, dpl.books
  end

  def test_publication_time_frame
    dpl = Library.new("Denver Public Library") 

    charlotte_bronte = Author.new({first_name: "Charlotte", 
                                   last_name: "Bronte"})
    harper_lee = Author.new({first_name: "Harper", 
                             last_name: "Lee"})    

    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")  
    professor = charlotte_bronte.write("The Professor", "1857")
    villette = charlotte_bronte.write("Villette", "1853") 
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee)

    expected_bronte = {
      :start => "1847", 
      :end => "1857"
    }

    expected_lee = {
      :start => "1960", 
      :end => "1960"
    }

    assert_equal expected_bronte, dpl.publication_time_frame_for(charlotte_bronte)
    assert_equal expected_lee, dpl.publication_time_frame_for(harper_lee)
  end

  def test_it_can_checkout_books
    dpl = Library.new("Denver Public Library") 

    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    harper_lee = Author.new({first_name: "Harper", last_name: "Lee"}) 

    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    villette = charlotte_bronte.write("Villette", "1853") 
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

    assert_equal false, dpl.checkout(mockingbird)
    assert_equal false, dpl.checkout(jane_eyre)

    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee) 

    assert_equal true, dpl.checkout(mockingbird)
    assert_equal true, dpl.checkout(jane_eyre)
  end

  def test_checked_out_books
    dpl = Library.new("Denver Public Library") 

    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    harper_lee = Author.new({first_name: "Harper", last_name: "Lee"}) 

    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    villette = charlotte_bronte.write("Villette", "1853") 
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee) 
    
    assert_equal [], dpl.checked_out_books

    assert_equal true, dpl.checkout(jane_eyre)
    assert_equal true, dpl.checkout(villette) 

    expected = [jane_eyre, villette]
    assert_equal expected, dpl.checked_out_books
  end

  def test_it_can_return_books
    dpl = Library.new("Denver Public Library") 

    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    harper_lee = Author.new({first_name: "Harper", last_name: "Lee"}) 

    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    villette = charlotte_bronte.write("Villette", "1853") 
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee) 

    assert_equal true, dpl.checkout(jane_eyre)
    assert_equal false, dpl.checkout(jane_eyre)

    dpl.return(jane_eyre)

    assert_equal [], dpl.checked_out_books
    assert_equal true, dpl.checkout(jane_eyre)
    assert_equal true, dpl.checkout(villette)
    assert_equal [jane_eyre, villette], dpl.checked_out_books
    assert_equal true,  dpl.checkout(mockingbird)
    
    dpl.return(mockingbird) 
    assert_equal true, dpl.checkout(mockingbird)

    dpl.return(mockingbird) 
    assert_equal true, dpl.checkout(mockingbird)
  end

  def test_it_can_find_most_popular_book
    dpl = Library.new("Denver Public Library") 

    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    harper_lee = Author.new({first_name: "Harper", last_name: "Lee"}) 

    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    villette = charlotte_bronte.write("Villette", "1853") 
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee) 

    assert_equal true, dpl.checkout(jane_eyre)
    assert_equal false, dpl.checkout(jane_eyre)

    dpl.return(jane_eyre)

    assert_equal [], dpl.checked_out_books
    assert_equal true, dpl.checkout(jane_eyre)
    assert_equal true, dpl.checkout(villette)
    assert_equal [jane_eyre, villette], dpl.checked_out_books
    assert_equal true,  dpl.checkout(mockingbird)
    
    dpl.return(mockingbird) 
    assert_equal true, dpl.checkout(mockingbird)

    dpl.return(mockingbird) 
    assert_equal true, dpl.checkout(mockingbird)

    assert_equal mockingbird, dpl.most_popular_book
  end
end