from enum import Enum


class Relationship(str, Enum):
    mother = "mother"
    father = "father"
    friend = "friend"
    best_friend = "best_friend"
    partner = "partner"
    brother = "brother"
    sister = "sister"
    teacher = "teacher"
    colleague = "colleague"
    other = "other"


class AgeGroup(str, Enum):
    age_5_9 = "5_9"
    age_10_19 = "10_19"
    age_20_24 = "20_24"
    age_25_29 = "25_29"
    age_30_39 = "30_39"
    age_40_49 = "40_49"
    age_50_plus = "50_plus"


class Gender(str, Enum):
    male = "male"
    female = "female"
    unspecified = "unspecified"


class Occasion(str, Enum):
    birthday = "birthday"
    wedding = "wedding"
    anniversary = "anniversary"
    graduation = "graduation"
    engagement = "engagement"
    thank_you = "thank_you"
    valentines_day = "valentines_day"
    eid = "eid"
    christmas = "christmas"
    other = "other"


class Interest(str, Enum):
    beauty = "beauty"
    skincare = "skincare"
    makeup = "makeup"
    books = "books"
    technology = "technology"
    computer_gadgets = "computer_gadgets"
    mobile_accessories = "mobile_accessories"
    sports = "sports"
    cricket = "cricket"
    fitness = "fitness"
    fashion = "fashion"
    jewelry = "jewelry"
    gaming = "gaming"
    travel = "travel"
    home_lifestyle = "home_lifestyle"
    food = "food"
    art_crafts = "art_crafts"
    other = "other"


class GiftStyle(str, Enum):
    practical = "practical"
    elegant = "elegant"
    luxury = "luxury"
    budget_friendly = "budget_friendly"
    personalized = "personalized"
    sentimental = "sentimental"
    fun = "fun"
    minimal = "minimal"
    self_care = "self_care"
    experience = "experience"


class Availability(str, Enum):
    in_stock = "in_stock"
    out_of_stock = "out_of_stock"
    unknown = "unknown"


class ErrorCode(str, Enum):
    VALIDATION_ERROR = "VALIDATION_ERROR"
    NOT_FOUND = "NOT_FOUND"
    METHOD_NOT_ALLOWED = "METHOD_NOT_ALLOWED"
    RATE_LIMITED = "RATE_LIMITED"
    DATABASE_ERROR = "DATABASE_ERROR"
    INTERNAL_ERROR = "INTERNAL_ERROR"

