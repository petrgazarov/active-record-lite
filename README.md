# ActiveRecord Lite
This is an ORM framework inspired by ActiveRecord which I built as an exercise to deeper understand the functionality of ActiveRecord.

## Cool features:

* SQLObject
  * ::all
  * ::find(id)
  * #attributes
  * #insert
  * #update
  * #save

* Searchable
  * ::where

* Associatable
  * #belongs_to
  * #has_many
  * #has_one_through

* DBConnection
  * ::execute
  * ::execute2
  * ::reset
  * ::open
