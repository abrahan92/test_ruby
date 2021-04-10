# Ruby Take Home Exercise

## Instructions:

- Make a branch, to present your solution in a PR
- We might comment or ask questions on the PR during the first days after
  deliver.
- The exercise can be solved in 3-4h depending on how ambitious your solution
  is. If you get stuck on something, re-scope the problem and solve the rest.
- Producing the correct solution is only one of the things we check in the
  code, please try to write code that represents your knowledge and skill.

## Excercise

Write a ruby script (CLI is enough) that fetches data from the API and:

- Compute the requested data in the most efficient manner possible (minimize
  time and memory needed)
- Use any library you want, but justify its convenience over the functionality
  provided/used.
  
And then prints the _requested stats_ to the standard output.

### Requested stats

When executed, your program must output the following information:

- Total number of orders
- Most and least popular product
- The median order value
- The product repurchased by the same customer in the shortest interval

When you provide your solution, make sure that any steps necessary to executed
it on any Unix are documented.

You can include code comments or separate notes to justify your choices, or
explain alternative strategies you considered, or potential improvements you
didi not have time to include.

## API

We have crafted a fake API for the purpose of the exercise. You can call it
with no authentication or special headers.

**Example request**

```
  curl https://shopifake.returnly.repl.co/orders.json?page=2
```
(hosted on repl.it this can take some time to wake up the first time you call)

**Example response:**

Status: 200 OK

```
  {
    "orders":[
      {
        "date": "2019-07-13T15:00Z",
        "customer_id": 3,
        "order_lines":[
          {
            "product_id": 1,
            "units": 2,
            "unit_price": 1000
          },
          ...
        ]
      },
      ...
    ],
    "page": 1,
    "total_pages": 2
  }
```

Error response:
Status: Non 2xx

```
    { "error": "error explanation" }
```
