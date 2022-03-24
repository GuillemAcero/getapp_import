# Getapp ImportC hallenge

Standalone elixir script application that parses and reads (imports) data from various files with various extensions depending on it's data provider.

# Getting Started
## Pre-requisites

  * Elixir v1.13

## Setup

Download the code

```
$ git clone https://github.com/GuillemAcero/getapp_import.git
```

Get all deps
```bash
$ mix deps.get
```

Build the script
```bash
$ mix escript.build
```

# Points of intereset

All the code of the script is located at `lib/getapp_import.ex` and the tests are in `test/getapp_import_test.exs`

<br/>

The structure to run the script is the following:
```bash
$ ./getapp_import <provider-name> <file-path>
```

If test wanted to be run, this is the following command:
```bash
$ mix test
```

# Considerations
- I asumed that the providers of the files (capterra and softwareadivce) gives use the files with a correct format inside. If that's not the case, then a task should be scheduled to modify some functions to handle those errors

- Another asumption is that each provider will always send the files with the same format (capterra a yaml, softwareadvice with json, etc etc)

- In theory, the providers param in the script (arg1) it's not necessary as long as the file name is the provider. We can just extract the name from the string, but I decided to keep it in that way bc it makes sense to have files with other names (like timestamps, dates, etc etc). I.e: 

  `$ ./getapp_import capterra priv/feed_products/24-3-2022.yaml`

- For future providers, it's only needed to add the function that considers it's filetype and add it to `@accepted_providers`. Easy to escalate.

- At the end of `main/1` funcitonality we could just add some call to some function to insert the data in a DB. Right now I just decided to just parse the file, show that I got the data in a Variable and end the process as this is a script.

- I would liked to do a Elixir App with a genserver that reads the files and store the data in the state of the genserver

- IMPORTANT: I decided to put the files inside the `priv/` folder so the file path is: `priv/feed_products/file-name.extension`. This decision was done bc the convention is to have files, images, etc.. in this folder.

- As when you run the script it's meaningful to see what this is returning, some IO.inspects are added to `main/1`. So when `mix test` is run a lot of inspects are shown. In a normal project, this inspects shouldn't be there.

# Usage Example

This are the 2 examples that work right now, without adding new files:
```bash
$ ./getapp_import capterra priv/feed_products/capterra.yaml

$ ./getapp_import softwareadvice priv/feed_products/softwareadvice.json
```

# List of errors and why they could happen

```bash
{:error, :invalid_number_of_arguments}

-> More than 2 arguments are given to the script
```

```bash
{:error, :invalid_provider}

-> Provider inside @accepted_providers variable or not a string
```

```bash
{:error, :invalid_path_type}

-> Path is not an string
```

```bash
{:error, :file_not_found}

-> File not found for the given path
```

```bash
{:error, :file_bad_extension}

-> The extension of the file is wrong for the given provider
```

```bash
{:error, :file_bad_structure}

-> Parsing the file has failed. Probably bad structure inside.
```





