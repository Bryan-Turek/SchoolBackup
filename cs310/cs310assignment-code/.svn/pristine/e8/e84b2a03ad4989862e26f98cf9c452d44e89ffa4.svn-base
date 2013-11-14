#!/usr/bin/env python

'''
LIFE: THE GAME
'''
character = {'stage': 'Birth'}
choice = {
    'Birth': {
        'description': 'You have entered the world. What will you do?',
        'options': '1) Go home with a family\n2) Flee the hospital to live with cats',
        'exits': {'1':'one', '2':'two'}
    },
    'one': {
        'description': 'You have chosen to go live with your family! What to do next?',
        'options': '1) Get a job\n2) Go to school\n3) Go live in the woods',
        'exits': {'1':'three', '2':'four' , '3':'five'}
    },
    'two': {
        'description': 'You crawl into an alley behind the hospital, filled with cats. They embrace you as their own. What to do next?',
        'options': '1) Go to school\n2) Go live in the woods\n3) Become cat president',
        'exits': {'1':'four', '2':'five' , '3':'six'}
    },
    'three': {
        'description': 'You decide to go get a minimum-wage job. Now what?',
        'options': '1) Start a family\n2) Work toward a better job',
        'exits': {'1':'seven', '2':'eight'}
    },
    'four': {
        'description': 'You have chosen to go to school. You thoroughly enjoy spending the best years of your life studying. Now what?',
        'options': '1) Start a family\n2) Get a hot new job',
        'exits': {'1':'seven', '2':'eight'}
    },
    'five': {
        'description': 'You take a page from Thoreau and go live in the woods. Now what?',
        'options': '1) Terrorize children at summer camp\n2) Become an acorn peddlar',
        'exits': {'1':'nine', '2':'ten'}
    },
    'six': {
        'description': 'After a long campaign of handing out catnip and petting kittens, you have been elected the president of cats! Now what?',
        'options': '1) Become somewhat normal and start a family\n2) Retire to Cat-topia',
        'exits': {'1':'seven', '2':'eleven'}
    },
    'seven': {
        'description': 'You meet someone, and create little someones. And now?',
        'options': '1) And...',
        'exits': {'1':'thirteen'}
    },
    'eight': {
        'description': 'You have taken an exciting job at Technology Man Co. What do you do now?',
        'options': '1) Slip into insanity\n2) Handle your money reasonably',
        'exits': {'1':'twelve', '2':'thirteen'}
    },
    'nine': {
        'description': 'After the Summer Camp for Excitable Teens is built near your cabin--and after finding a rather menacing pickaxe--you decide to dress up as an evil dwarf and terrorize summer camp goers. And now?',
        'options': '1) And...',
        'exits': {'1':'thirteen'}
    },
    'ten': {
        'description': 'Unfortunately, you are the only human in the woods, and squirrels are fairly good at finding acorns on their own. And now?',
        'options': '1) And...',
        'exits': {'1':'thirteen'}
    },
    'eleven': {
        'description': 'You have decided to retire to Cat-topia. Cat food is shaped into your image, and birds are sacrificed to you daily. And now?',
        'options': '1) And...',
        'exits': {'1':'thirteen'}
    },
    'twelve': {
        'description': 'You have become a deranged millionare. Your days are spent in tribal garb, and working on your "Moustaches of the Apocalypse" diorama. And now?',
        'options': '1) And...',
        'exits': {'1':'thirteen'}
    },
    'thirteen': {
        'description': 'Congratulations, you are dead!',
        'options': 'RIP in peace',
        'exits': {'1':'thirteen'}
    }
}
print "Congratulations, you have been born!"
while True:
    next = choice[character['stage']]
    command = raw_input(next['description'] + ' > ')
    command_parts = command.split(None, 1)
    next_stage = command_parts[0]
    if next_stage in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13']:
        if next_stage in next['exits']:
            character['stage'] = next['exits'][next_stage]
            next = choice[character['stage']]
        else:
            print 'You cannot do that. Enter "o" for options.'
    elif next_stage not in ['o', 'quit', 'exit', 'stop']:
            print 'You cannot do that. Enter "o" for options.'
    if next_stage == 'o':
	print next['options']
    if next_stage in ['quit', 'exit', 'stop']:
        print 'Goodbye'
        break
