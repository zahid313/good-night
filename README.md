# Good Night
Good Night is a social network for sleep tracking. Users can create sleep records, follow other users, and view their friends' sleep records.

# Setting up the Good Night API with Docker

## Prerequisites

    Docker and Docker-compose should be installed on your machine.
    You should have a basic understanding of how to use Docker and Docker-compose.

## Steps

1. Clone the project from the repository

        $ git clone https://github.com/zahid313/good-night.git

2. Navigate to the project directory

        $ cd good-night

3. Build the Docker images and start containers using the following command

        $ docker-compose up --build -d

4. Prepare the database

        $ docker exec good-night-api rails db:prepare

5. Run the tests

        $ docker exec good-night-api rails test

5. View the documentation

        Documentation can be viewed by visiting localhost:3000/api-docs.html

5. Postman Collection has been included as well.     

6. To stop the containers, use the following command

        $ docker-compose down    



## Additional Information

The **docker-compose.yml** file has the configurations for the following services.

1. good-night-api: The Good Night API
2. good-night-db: The database


* The web service uses the Dockerfile in the project root to build the image.
* You can access the application by visiting http://localhost:3000 in your browser.
* If you make any changes to the database, you must run the migrations using 

        $ docker-compose exec good-night-api  rails db:migrate

    

## Conclusion

This project is set up with Docker, which makes it easy to run the application in different environments. The above steps should help you in setting up the project on your machine. In case of any issues or if you have any questions, please feel free to reach out to the project maintainers.


## Usage

Once the server is running, you can access the Good Night API at http://localhost:3000/api/v1.

The API has the following endpoints:

    /users: CRUD operations for users.
    /sleep_records: CRUD operations for sleep records.
    /follows: CRUD operations for follows.
    /friend_sleep_records: View the sleep records of a user's friends.

For more information on using the API, see the documentation at http://localhost:3000/api-docs.


## Contributing

If you'd like to contribute to Good Night, please follow these steps:

    1. Fork the repository.
    2. Create a new branch for your changes.
    3. Make your changes and write tests for them.
    4. Push your changes to your fork.
    5. Create a pull request.


Happy Development

:+1: :sparkles: :camel: :tada:
:rocket: :metal: :octocat: