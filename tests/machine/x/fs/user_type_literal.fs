// Generated by Mochi compiler v0.10.27 on 2025-07-17T07:48:57Z
open System

type Anon1 = {
    name: string
    age: int
}
type Anon2 = {
    title: string
    author: Anon1
}
type Person = {
    mutable name: string
    mutable age: int
}
type Book = {
    mutable title: string
    mutable author: Person
}
let book: Anon2 = { title = "Go"; author = { name = "Bob"; age = 42 } }
printfn "%A" (book.author.name)
