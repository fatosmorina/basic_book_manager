require_relative '../../services/book_manager'
require_relative '../../models/author'
describe 'BookManager' do

  it 'should not get a book without any parameters given' do
    allow(Book).to receive(:find_by)
    result = BookManager.get(nil, nil, nil)
    expect(result).to eq("Book was not found.")
  end

  it 'should get a book by title' do
    title = 'Ego is the enemy'
    book = double(Book, find_by: true)
    allow(Book).to receive(:find_by).and_return(book)
    result = BookManager.get(title, nil, nil)
    expect(result).to eq(book)
  end

  it 'should get a book by isbn' do
    book = double(Book)
    allow(Book).to receive(:find_by).and_return(book)
    output = BookManager.get(nil, 'isbn', nil)
    expect(output).to eq(book)
  end

  it 'should get a book by author' do
    author = double(Author)
    book = double(Book, find_by: true)
    allow(Author).to receive(:find_by).and_return(author)
    allow(Book).to receive(:find_by).and_return(book)
    output = BookManager.get(nil, nil, author)
    expect(output).to eq(book)
  end

  it 'should not add a book with an empty title' do
    output = BookManager.add('', '', '')
    expect(output).to eq("Book title cannot be empty.")
  end

  it 'should not add a book with an empty ISBN' do
    output = BookManager.add('Ego is the enemy', '', '')
    expect(output).to eq("Book ISBN cannot be empty.")
  end

  it 'should not add a book without an author' do
    output = BookManager.add('Ego is the enemy', 'ISBN', nil)
    expect(output).to eq("Book author cannot be empty.")
  end

  it 'should add a book with an existing author' do
    author = class_double(Author, find_by: true)
    book = double(Book)
    allow(Author).to receive(:find_by).and_return(author)
    allow(Book).to receive(:create)
    expect(Book).to receive(:create)
    output = BookManager.add('Ego is the enemy', 'ISBN', author)
    expect(output).to eq('Book was added successfully.')
  end

  it 'should add a book with a new author' do
    author = double(Author, find_by: true, create: true, age: 28, name: 'Ryan Holiday')
    book = double(Book)
    allow(Author).to receive(:find_by).and_return(author)
    allow(Author).to receive(:create)
    allow(Book).to receive(:create).and_return(book)
    allow(AuthorManager).to receive(:get)
    expect(Book).to receive(:create)
    expect(Author).to receive(:create)
    output = BookManager.add('Ego is the enemy', 'ISBN', author)
    expect(output).to eq('Book was added successfully.')
  end


end