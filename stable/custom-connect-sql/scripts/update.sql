use AdventureWorks
GO
update person.Person
set ModifiedDate = GETDATE()
WHERE 1=1
GO
