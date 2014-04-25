## Purdue CS User search

Have you ever wanted to figure out exactly where a person was logged in from? 

This utility allows you to do exactly that. It polls all the CS computers and executes a search for the given user. 

## Plans for project

I will eventually integrate this with messaging a user so that you can input a username and it will connect you to their terminal to send a message. 


### Usage

    ./getAllUsers.bash -u USERNAME [-t TERMINAL] [-v|-f|-?|-h]
    -u USERNAME
        The username of the user to search for.
    -t TERMINAL
        The terminal the user is logged in on. Allows for immediate messaging of a user.
    -v
        Verbose output
    -f
        Force an update of the users log. This can take a while, so default operation reuses files under 30m old
    -h | -?
        Display this help
		
