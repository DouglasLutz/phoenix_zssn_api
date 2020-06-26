# Zssn

To start the server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

## Routes

### Survivors

The routes are the following:

- POST /survivors: Adds a new survivor and it's inventory.

Expected request boby:
```json
{
    "name": "Some name",
    "age": 31,
    "gender": "Male",
    "latitude": 60.323034,
    "longitude": 71.872034,
    "survivor_items": [
    	{
	        "item_id": 3,
	        "quantity": 10
		}, {
	        "item_id": 4,
	        "quantity": 10
	    }
    ]
}
```

Note: After creation a survivor inventory can only be changed by trading so be careful when specifing it's belongings.

- GET /survivors: Returns all registered survivors.

- GET /survivors/:id: Returns a specific survivor by it's id.

Expected request boby:
```json
{
    "latitude": 59.323034,
    "longitude": 61.872034,
}
```

- PUT /survivors/infection/:id: Reports a survivor as infected.

- GET /survivors/info: Returns useful information about the apocalipse.

### SurvivorItems

- PUT /trade: Trades items between survivors.

Expected request boby:
```json
{
	"trade_items_1": [
        {
	        "item_id": 1,
	        "survivor_id": 2,
	        "quantity": 1
		}, {
            "item_id": 2,
	        "survivor_id": 2,
	        "quantity": 1
        }
    ],
    "trade_items_2": [
    	{
	        "item_id": 3,
	        "survivor_id": 3,
	        "quantity": 3
	    }, {
          "item_id": 4,
	        "survivor_id": 3,
	        "quantity": 1
        }
    ]
}
```

* Notes:
    * the survivors must have enough items to trade
    * trade_items_1 must contain the same total value of trade_items_2
    * the same item cannot apear in trade_items_1 and trade_items_2

### Items

- GET /items: Returns all registered items.

- POST /items: Adds a new item.

- GET /items/:id: Returns a specific item by it's id.

- PUT /items/:id: Updates an item.
```json
{
    "value": 6
}
```
