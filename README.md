# OutdoorSY
## About
A rudimentary JSON API designed to accept a .txt file of customer records, parse the data from the file, and return a formatted and optionally sorted selection of the data on request. Uploaded data may use comma or pipe delimiters.

## Functionality
There are three JSON endpoints available:
* `POST /api/v1/customer_lists`
* `DELETE /api/v1/customer_lists/:id`
* `GET /api/v1/customer_lists/:customer_list_id/list_records`

Error handling is largely delegated to ActiveRecord, but some additional elementary handling is in place in the event of a requested customer list not existing.

With a local server running, cURL or [Postman](https://www.postman.com/) are good tools for exercising these endpoints.

### POST /api/v1/customer_lists
This endpoint accepts a .txt file uploaded as a parameter under `customer_lists[:list]`. A created list is stored using ActiveStorage and automatically parsed to create `CustomerRecord` objects. The uploaded file is stored unaltered, while records stored in the database undergo minor cleaning (excess whitespace is stripped, characters are capitalized, and the `vehicle_length` value has any measurement types removed) and validation (required presence of `first_name`, `last_name`, and `vehicle_type`).

Example:
```
$ curl --include --request POST http://localhost:3000/api/v1/customer_lists --form "customer_lists[list]=@<your_system_path>/outdoorsy/spec/test_data/pipes.txt"
```

Example of a successful response:
```json
// HTTP/1.1 201 Created
{
  "id": 1,
  "filename": "pipes.txt",
  "num_records": 4
}
```

Example of an unsuccessful response:
```json
// HTTP/1.1 404 Not Found
{
  "errors": ["Filename has already been taken"]
}
```

### DELETE /api/v1/customer_lists/:id
This endpoint provides a way to destroy a previously created `CustomerList`, as well as its associated uploaded file and `CustomerRecord`s.

Example:
```
$ curl --request DELETE http://localhost:3000/api/v1/customer_lists/1
```

Example of a successful response:
```json
// HTTP/1.1 204 No Content
```

Example of an unsuccessful response:
```json
// HTTP/1.1 404 Not Found
{
  "errors": ["CustomerList does not exist"]
}
```

### GET /api/v1/customer_lists/:customer_list_id/list_records
This endpoint provides a way for the user to see all of the records belonging to one of their uploaded lists. It accepts an optional `order_by` parameter that accepts values of `full_name` or `vehicle_type`, with unsupported values being ignored.

Example (without ordering):
```
$ curl --request GET http://127.0.0.1:3000/api/v1/customer_lists/1/list_records
```

Example of a successful response:
```json
// HTTP/1.1 200 Ok
[
  {
    "full_name": "ADAMS, ANSEL",
    "email": "A@ADAMS.COM",
    "vehicle_type": "MOTORBOAT",
    "vehicle_name": "RUSHING WATER",
    "vehicle_length": 24
  },
  {
    "full_name": "IRWIN, STEVE",
    "email": "STEVE@CROCODILES.COM",
    "vehicle_type": "RV",
    "vehicle_name": "G’DAY FOR ADVENTURE",
    "vehicle_length": 32
  },
  {
    "full_name": "CEESAY, ISATOU",
    "email": "ISATOU@RECYCLE.COM",
    "vehicle_type": "CAMPERVAN",
    "vehicle_name": "PLASTIC TO PURSES",
    "vehicle_length": 20
  },
  {
    "full_name": "UEMURA, NAOMI",
    "email": "N.UEMURA@GMAIL.COM",
    "vehicle_type": "BICYCLE",
    "vehicle_name": "GLACIER GLIDER",
    "vehicle_length": 5
  }
]
```

Example of an unsuccessful response:
```json
// HTTP/1.1 404 Not Found
{
  "errors": ["CustomerList does not exist"]
}
```

Example request with ordering:
```
$ curl --request GET http://127.0.0.1:3000/api/v1/customer_lists/1/list_records --form "order_by=vehicle_type"
```

Example successful ordered response (truncated):
```json
// HTTP/1.1 200 OK
[
  {
    "full_name": "UEMURA, NAOMI",
    "email": "N.UEMURA@GMAIL.COM",
    "vehicle_type": "BICYCLE",
    "vehicle_name": "GLACIER GLIDER",
    "vehicle_length": 5
  },
  // Additional records omitted for demonstration purposes
  {
    "full_name": "IRWIN, STEVE",
    "email": "STEVE@CROCODILES.COM",
    "vehicle_type": "RV",
    "vehicle_name": "G’DAY FOR ADVENTURE",
    "vehicle_length": 32
  }
]
```
## Assumptions
I sought to clarify a number of points from the original requirements, including:
* Should only .txt files be accepted? If so, what is the desired behavior when an unsupported file type is presented?
  * _Decided to handle with a validation._
* The sample data contains no header rows. Is it safe to assume that a header row will not be present in uploaded data? If not, what is the desired behavior when a header row is present?
  * _Moved forward with the assumption that header rows would not be present._
* Can we assume that the data is always presented in the same order within the files? i.e., the first piece of data will always be the First name and the last will always be the Vehicle length etc?
  * _Moved forward with the assumption that this would be true._
* Is the user expected to supply what the separator character is (comma or pipe) or should the system automatically detect?
  * _Handled via the system automatically detecting the delimiter from a whitelist._
* What is the desired behavior for duplicate data?
  * _Moved forward with the assumption that duplicate data would not be present._
* Does any data validation need to take place, or can we assume received data is good and can be stored as-is as text and without the need for any normalization or cleansing? I'm specifically noticing that there is variability in the sample data around Vehicle length, with some entries designating feet by "feet" or "ft" and others using an apostrophe. Additionally, can we expect only integer measurements in feet?
  * _The uploaded file is stored unaltered, while records stored in the database undergo minor cleaning (excess whitespace is stripped, characters are capitalized, and the `vehicle_length` value has any measurement types removed) and validation (required presence of `first_name`, `last_name`, and `vehicle_type`)._
* For the ordering and presentation of the Full name? Should this be shown and ordered as `"<First name> <Last name>"`, or by `"<Last name>, <First name>"`?
  * _Decided to use `"<Last name>, <First name>"`._
* What is the expected behavior when a subsequent file is uploaded? Should the system handle only the data from a single file at a time or should it add to data previously updated?
  * _Decided for the system to handle and store multiple files, but for the current version of this app to only present data from a single file at a time._
## Setup
**Note: this project is built on Rails 7 and uses Ruby 2.7.3**

Clone this repository, cd into the project directory and bundle:
```
$ bundle
```

Set up the database:
```
$ bundle exec rails db:{create,migrate}
```

Run a local server to accept requests:
```
$ bundle exec rails s
```
### Running tests
There is a full test suite written in RSpec. You can run from the project root with:
```
$ bundle exec rspec
```
