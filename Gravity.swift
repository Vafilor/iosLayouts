import Foundation

enum Gravity : Int {
    case Left = 0b1
    case Right = 0b10
    case CenterHorizontal = 0b100
    case Bottom = 0b1000
    case Top = 0b10000
    case CenterVertical = 0b100000
    case Center = 0b100100 //CenterVertical | CenterHorizontal
    case FillHorizontal = 0b1000000
    case FillVertical = 0b10000000
    case Fill = 0b11000000 //FillHorizontal | FillVertical
}