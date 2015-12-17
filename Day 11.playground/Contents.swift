import Foundation

var password = "hxbxwxba"
for _ in 1...2 {
    password = getNextValidPassword(password)
    print(password)
}
