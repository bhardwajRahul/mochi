open System
open System.Text.Json

type Anon1 = {
    name: string
    age: int
}
let people: obj list = [{ name = "Alice"; age = 30 }; { name = "Bob"; age = 25 }]
(List.iter (fun row -> printfn "%s" (JsonSerializer.Serialize(row))) people)
