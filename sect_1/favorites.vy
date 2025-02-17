# pragma version 0.4.0
# @licence MIT

#favorite things list:
#favorite numbers
#favorite people with their favorite number

my_fav_num: public(uint256)

my_nums_list: public(uint256[5])
index: uint256

struct Person:
    person_name: String[100]
    person_fav_num: uint256

person_list: public(Person[5])
    

name_to_fav_num: public(HashMap[String[100], uint256])

@deploy
def __init__():
    self.my_fav_num = 6
    self.index = 0
    self.person_list[3] = Person(person_name = "Chris", person_fav_num = 8)

@external
def store(new_num: uint256):
    self.my_fav_num = new_num

@external
@view
def retrieve() -> uint256:
    return self.my_fav_num


@external 
def add_number(name: String[100], added_num: uint256):
    self.my_nums_list[self.index] = added_num

    new_person: Person = Person(person_name = name, person_fav_num = added_num)

    self.person_list[self.index] = new_person

    self.name_to_fav_num[name] = added_num

    self.index = self.index + 1

@external
@view
def add() -> uint256:
    return self.my_fav_num + 1


