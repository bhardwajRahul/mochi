-- Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
Person = {}
Person.__index = Person
function Person.new(o)
    o = o or {}
    setmetatable(o, Person)
    return o
end

Book = {}
Book.__index = Book
function Book.new(o)
    o = o or {}
    setmetatable(o, Book)
    return o
end

book = {title="Go", author={name="Bob", age=42}};
print(book.author.name);
