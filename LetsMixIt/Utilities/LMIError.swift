

import Foundation

enum LMIError: String, Error {
    case invalidData = "Произошла ошибка во время загрузки коктейлей. Попробуй еще раз."
    case unableToFavorite = "Произошла ошибка во время выставления лайка. Попробуй еще раз."
    case alreadyInFavorites = "Ты уже добавил этот коктейль в понравившиеся."
    case somethingWentWrong = "Что-то пошло не так. Попробуй еще раз!"
}
