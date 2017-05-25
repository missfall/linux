from itertools import izip

def get_tickets_list():
    logo = "*************************** Ticket Details ***************************"
    print logo
    ticket_count = raw_input("Enter number of Ticket: ")
    ticket_nums=[]
    for i in  range(int(ticket_count)):
        ticket_num = raw_input("Enter the ticket number %s: " % i)
        ticket_nums.append(ticket_num)
    print "*"*len(logo) + "\n"
    return ticket_nums

def get_users_list():
    logo = "**************************** User Details ****************************"
    user_count = raw_input("Enter total number of team member: ")
    users=[]
    for i in  range(int(user_count)):
        user = raw_input("Enter user name: ")
        users.append(user)
    print "*"*len(logo) + "\n"
    return users

def chunk_list(mylist, chunk_size):
    return (mylist[i:i+chunk_size] for i in xrange(0, len(mylist), chunk_size))

def assign_tickets_randomly():
    from random import shuffle
    tickets = get_tickets_list()
    users = get_users_list()
    random_tickets = shuffle(tickets) # why shuffle here and not directly in get_tickets_list() ?
    ticket_chunks = chunk_list(tickets, len(users))
    ticket_mapping = dict(izip(users, ticket_chunks))
    return ticket_mapping

ticket_assignment = assign_tickets_randomly()
print ticket_assignment
