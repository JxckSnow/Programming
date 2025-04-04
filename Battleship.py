import random

ships = [("Battleship", 3),
         ("Attacker", 2),
         ("Submarine", 1),
         ("War Ship", 4),
         ("Destroyer Class", 5)]


##function to create the battleship board
def createBoard():
    board = [['~' for _ in range(10)] for _ in range(10)]
    return board


def createDisplayBoard():
    disboard = [['~' for _ in range(10)] for _ in range(10)]
    for i in disboard:
        print(" ".join(i))
    return disboard


def placeShips(board, size):
    is_placed = False
    while not is_placed:
        # Choose an orientation (0 is vert and 1 is hori)
        orientation = random.randint(0, 1)

        # Vertical random placement
        if orientation == 0:
            # Makes sure the ship will fit when vertically aligned
            row = random.randint(0, len(board) - size)
            col = random.randint(0, len(board[0]) - 1)

            if all(board[row + i][col] == '~' for i in range(size)):
                for i in range(size):
                    board[row + i][col] = '.'  # Place the ship vertically
                is_placed = True

        else:
            row = random.randint(0, len(board) - 1)
            col = random.randint(0, len(board[0]) - size)

            if all(board[row][col + i] == '~' for i in range(size)):
                for i in range(size):
                    board[row][col + i] = "."  # places ship horizontally
                is_placed = True


def playerGuess(board):
    tries = 0
    while tries <= 30:
        playerCoordinates = input("Enter the position (coordinates) you want to hit: ")
        if playerCoordinates.lower() == 'exit':
            break

        userRow, userCol = playerCoordinates.split(',')

        u_row = int(userRow.strip())
        u_col = int(userCol.strip())

        if len(board) >= u_row >= 0 and len(board[0]) >= u_col >= 0:
            if board[u_row][u_col] == '.':
                print("You've hit a ship!")
                board[u_row][u_col] = '*'
                disboard[u_row][u_col] = '*'
                for i in disboard:
                    print(" ".join(i))
            else:
                print("Miss! Try again")
                board[u_row][u_col] = 'O'
                disboard[u_row][u_col] = 'O'
                for i in disboard:
                    print(" ".join(i))
            tries = + 1
            shipCount = []
            for row in board:
                shipCount.append(row.count("."))
            totalShips = sum(shipCount)
            if totalShips == 0:
                print("Congratulations! You've hit all the ships")
        else:
            print(f"Coordinates must be between 0 and {len(board) - 1}. Please try again.")
    if tries > 30:
        print("Sorry you have used all your tries. Please start another game!")


##Will start all the game from the user replying
userReady = input("Welcome to Battleship!\nPlease type 'ready' to begin playing.\n")
print("")

if userReady.lower() == 'ready':
    print("If you ever want to stop playing please type 'exit'")
    print("-------------------------------------------------------------------------------------")
    userRules = input(
        "Here are a few notes. We entering coordinates make sure they are between 0 and 9.\nAlso, type them in with this format: 'x, y'.\nIf you understand enter 'ok'.\n")
    print("")
    if userRules.lower() == 'ok':
        print("Below is your reference board. The board is 0 - 9 (10 spaces total)")
        print("")
        board = createBoard()
        disboard = createDisplayBoard()
        placeShips(board, 3)
        placeShips(board, 2)
        placeShips(board, 1)
        placeShips(board, 4)
        placeShips(board, 5)
        playerGuess(board)
    else:
        print("Sorry! Please ensure you understand the rules.")
else:
    print("Please make sure you are ready.")

# shipCount = []
# for row in board:
#     shipCount.append(row.count("."))
# totalShips = sum(shipCount)
# if totalShips == 0:
#     print("Congratulations! You've hit all the ships")
# if not any('.' in row for row in board):
#     print("Congratulations! You've hit all the ships")
#     break
