# Keyword Association Application
This is a sample app created for the keyword association task given by Redbubble.
The package will contain the following.

## R codes
The following R codes are defined in this project:

### main.R
This is the main file responsible for getting the dataset and performing text analysis and extracting the association between the submitted query and the documents (tags) within the dataset.

### keywordAssoc\_API.R
This is the API written to send requests and receive responses to and from the `main.R` file. 

### caller.R
This is the Plumber file which will run the plumber library in getting access to the API defined in the `keywordAssoc_API.R` file.

## R tests
These are files defined under the `tests` folder to perform the Unit Testing over the implemented functions. They will use the `testthat` R Package for this purpose.

## Docker File
The `dockerfile` in the root directory accounts for the link to Docker (for building and running the application).

## Datasets
The datasets are not uploaded as they exceed the file size limit of GitHub. They will be accessible through RB's website.

