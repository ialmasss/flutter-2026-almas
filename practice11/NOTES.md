# Practice 11: A Real Server — Notes

## Level 1: Postman Analysis

* **Endpoint:** `GET https://jsonplaceholder.typicode.com/users`
* **Status:** `200 OK`
* **Content-Type:** `application/json; charset=utf-8`
* **Total Users:** 10
* **Nested objects:** `address`, `company`
* **Doubly nested objects:** `address.geo`
* **GET `/users/999`:** Status `404 Not Found`, body `{}`
* **POST `/users`:** Status `201 Created`, server echoes back the sent JSON and appends `"id": 11`
* **GET `/users?id=3`:** Status `200 OK`, returns a JSON array containing 1 user object `[{...}]`

### Top-Level `User` Fields
| Field | JSON Type | Dart Type | Nullable? |
| :--- | :--- | :--- | :--- |
| `id` | number | `int` | No |
| `name` | string | `String` | No |
| `username` | string | `String` | No |
| `email` | string | `String` | No |
| `phone` | string | `String` | No |
| `website` | string | `String?` | Yes |
| `address` | object | `Address` | No |
| `company` | object | `({String name, String catchPhrase})` | No |

### Nested `Address` Fields
| Field | JSON Type | Dart Type | Nullable? |
| :--- | :--- | :--- | :--- |
| `street` | string | `String` | No |
| `suite` | string | `String` | No |
| `city` | string | `String` | No |
| `zipcode` | string | `String` | No |
| `geo` | object | `Geo` | No |

### Doubly Nested `Geo` Fields
| Field | JSON Type | Dart Type | Nullable? |
| :--- | :--- | :--- | :--- |
| `lat` | string | `double` (via `double.parse`) | No |
| `lng` | string | `double` (via `double.parse`) | No |

### Nested `Company` Fields
| Field | JSON Type | Dart Type | Nullable? |
| :--- | :--- | :--- | :--- |
| `name` | string | `String` | No |
| `catchPhrase` | string | `String` | No |
| `bs` | string | *(ignored)* | — |

---

## Level 5: Two Kinds of "No Network" Timings

1. **Airplane Mode (Immediate OS route failure):**
    * **Exception:** `SocketException` -> mapped to `NoConnectionException`
    * **Time to Offline UI:** `~0.1s` (immediate, under 1 second)

2. **Connected Wi-Fi with No Internet Access (Packet drop / blackhole):**
    * **Exception:** `TimeoutException` -> mapped to `NoConnectionException`
    * **Time to Offline UI:** `10.0s` (triggered by `.timeout(Duration(seconds: 10))`)