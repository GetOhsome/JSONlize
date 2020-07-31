# JSONlize-Swift

A simple swift package for localizing your apps from JSON files with easy plural and dictionary handling.

# Usage

## Initialization

##### Example:

```swift
JSONlize.shared.load(
    fileHandler: { language in 
        //language: current system language string like "en-US"
        return Bundle.main.url(forResource: "lang.\(language)", withExtension: "json") //returning an URL for file e.g. "lang.en-US.json"
    },
    defaultLanguage: "en-US" //fallback language if json file for current system language is not found
)
```

Load a file with the `load(fileHandler: Filehandler, defaultLanguage: String)` function.

`Filehandler`: is a block that passes the current preferred system language as `String` for example `"de-DE"`.
The block can return an optional object of type `URL` to the desired JSON file. If `nil` is returned, JSONLocalize calls the Filehandler block again for the default language set. In this Example `"en-US"`.

`defaultLanguage`: The language to fallback to, if the file for the desired language is not found.

## Types

There are 3 different kinds of Strings that can be localized with `JSONLize.LocalizedType`.

```swift
enum LocalizedType {
    case string
    case plural(_ input: Int)
    case dict(_ key: String)
}
```

Following examples use these JSON example files:

#### lang.en-US.json

```json
{
  "sentence": "This is a testsentence.",
  "category": {
    "keys": {
      "travel": "Travel",
      "art": "Art",
      "food": "Food"
    }
  },
  "comment": {
    "plurals": {
      "1": "Comment",
      "*": "Comments"
    }
  },
  "commentCount": {
    "plurals": {
      "1": "${i} Comment",
      "*": "${i} Comments"
    }
  }
}
```

#### lang.de-DE.json

```json
{
  "sentence": "Das ist ein Satz.",
  "category": {
    "keys": {
      "travel": "Reisen",
      "art": "Kunst",
      "food": "Essen"
    }
  },
  "comment": {
    "plurals": {
      "1": "Kommentar",
      "*": "Kommentare"
    }
  },
  "commentCount": {
    "plurals": {
      "1": "${i} Kommentar",
      "*": "${i} Kommentare"
    }
  }
}
```

## Strings

use `.JSONlized` on any String to get the localized value

#### Example

```swift
//en-US
"sentence".JSONlized //Output: "This is a testsentence."

//de-DE
"sentence".JSONlized //Output: "Das ist ein Satz."
```

alternatively you can use `.JSONlized(.string)` to achieve the same result.

## Dictionaries

use `JSONlized(_ localizedType: JSONlize.LocalizedType)` with `.dict` as `JSONlize.LocalizedType` on any String to get the localized value of a dictionary value.

`.dict(_ key: String)` takes a `String` as parameter for the **key** to look up.

#### Example

```swift
//en-US
"category".JSONlized(.dict("travel")) //Output: "Travel"
"category".JSONlized(.dict("art")) //Output: "Art"
"category".JSONlized(.dict("food")) //Output: "Food"

//de-DE
"category".JSONlized(.dict("travel")) //Output: "Reisen"
"category".JSONlized(.dict("art")) //Output: "Kunst"
"category".JSONlized(.dict("food")) //Output: "Essen"
```

## Plurals

use `JSONlized(_ localizedType: JSONLocalize.LocalizedType)` with `.plural` as `JSONLocalize.LocalizedType` on any String to get the localized value of a plural value.

`.plural(_ input: Int)` takes an `Int` as parameter for the **key** to look up.

#### Example

```swift
//en-US
"comment".JSONlized(.plural(0)) //Output: "Comments"
"comment".JSONlized(.plural(1)) //Output: "Comment"
"comment".JSONlized(.plural(2)) //Output: "Comments"

//de-DE
"comment".JSONlized(.plural(0)) //Output: "Kommentare"
"comment".JSONlized(.plural(1)) //Output: "Kommentar"
"comment".JSONlized(.plural(2)) //Output: "Kommentare"
```

# JSON

### Plurals

#### Default value

In a JSON plural definition, use the key `"*"` for all other cases.

##### Example:

JSON:

```json
"comment": {
    "plurals": {
        "1": "Comment",
        "*": "Comments"
    }
}
```

Swift:

```swift
//en-US
"comment".JSONlized(.plural(0)) //Output: "Comments" value of "*"
"comment".JSONlized(.plural(1)) //Output: "Comment" value of "1"
"comment".JSONlized(.plural(2)) //Output: "Comments" value of "*"
```

#### Input

Its possible to define `${i}` in your plural values, which will be replaced by the input value.

##### Example:

JSON:

```json
"commentCount": {
    "plurals": {
        "1": "${i} Comment",
        "*": "${i} Comments"
    }
}
```

Swift:

```swift
"commentCount".JSONlized(.plural(0)) //Output: "0 Comments" replaced ${i} with 0
"commentCount".JSONlized(.plural(1)) //Output: "1 Comment" replaced ${i} with 1
"commentCount".JSONlized(.plural(2)) //Output: "2 Comments" replaced ${i} with 2
```
