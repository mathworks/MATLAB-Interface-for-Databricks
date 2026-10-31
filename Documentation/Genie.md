# Genie - Public Preview

>Please note that Databricks&reg; labels the Genie API as public preview with parts of it labelled as beta.

The Genie API enables integration of natural language data querying into applications
It supports stateful conversations, allowing follow-up questions. The Genie application
is exposed in the following ways:

1. The REST API via the `databricks.Genie` class.
2. A high-level chatbot based experience via `matlab.databricks.startGenieChat()`.

Using Genie requires a configured "Genie Space". The space defines the context that
Genie uses to interpret questions and return results. It must have:

* Access to a Databricks workspace with the Databricks SQL entitlement.
* At least CAN USE privileges on a SQL pro or serverless SQL warehouse.

The `databricks.Genie` API can be accessed directly as per the many other exposed
REST APIs.

## `databricks.Genie` interface

Example:

```matlab
% Create a Genie top-level object object
g = databricks.Genie;

% List the available spaces
[result, errorResponse] = g.listSpaces;

% Use the first returned space assuming it is the intended one
spaceId = result.spaces(1).spaceId;

% Start a conversation
content = "What tables are there and how are they connected? Give me a short summary.";
[result, errorResponse] = g.startConversation(spaceId, content);
conversationId = result.conversationId;
messageId = result.messageId;

% Allow some time for the response to be generated, can be tested using statue/state values
[result, errorResponse] = g.getConversationMessage(spaceId, conversationId, messageId);

% Display text based response a query is not generated in this case
fprintf("Response text:\n\n %s\n\n", result.attachments(1).text.content)

Response text:

 There are two tables: `main`.`default`.`outages` and `main`.`default`.`deeply`. 

The `outages` table contains information about power outages, including columns for region, outage time, loss, customers affected, restoration time, and cause. 

The `deeply` table contains structured data with columns for id, name, info (a struct with nested fields), arr (an array of integers), and as (an array of structs). 

There is no explicit connection or relationship between these two tables based on the provided schema.


%% Trigger a query that responds with a query not text
content = "count the number of rows in outages";
[result, errorResponse] = g.createConversationMessage(spaceId, conversationId, content);
messageId = result.messageId;

% wait for a response to be generated
[result, errorResponse] = g.getConversationMessage(spaceId, conversationId, messageId);
result.attachments(1)
ans = 
  Attachment with properties:

    attachmentId: "01f08c84005e11df8c940d586e5f82bb"
           query: [1x1 databricks.datastructures.genie.Query]
            text: [0x0 databricks.datastructures.genie.Text]

result.attachments(1).query.query
ans = 
    "SELECT COUNT(*) FROM `main`.`default`.`outages`"

% Execute the generated query
attachmentId = result.attachments(1).attachmentId;
[result, errorResponse] = g.execMsgAttachmentSQLQuery(spaceId, conversationId, messageId, attachmentId);

% Convert the response to a MATLAB table
T = databricks.internal.genie.statementResponse2Table(result.statementResponse)
Renamed column: count(1) to: count_1_
T =
  table
    count_1_
    ________
      1468  
```

>Note: `statementResponse2Table` is a partial implementation and does not currently support
>all data type or table configurations, for support contact <databricks@mathworks.com>.

For full REST API details see also: [https://docs.databricks.com/aws/en/genie/conversation-api](https://docs.databricks.com/aws/en/genie/conversation-api).

## `matlab.databricks.genie.Genie` interface

`matlab.databricks.Genie` is a higher-level set of classes that can make it easier
to work with Genie. At the highest level is the `chat` method which provides a
basic chatbot like experience akin to that available in the Databricks Workspace.

```matlab
matlab.databricks.startGenieChat
Starting chat. To stop type 'exit chat' or 'quit chat' at the prompt.
---------------------------------------------------------------------
Prompt: What tables are there and how are they connected? Give me a short summary.
..
Text: There are two tables: `main`.`default`.`outages` and `main`.`default`.`deeply`. 

- The `outages` table contains information about power outages, including columns for region, outage time, loss, customers affected, restoration time, and cause.
- The `deeply` table contains various structured data, including an ID, name, and a complex `info` struct with nested fields.

There is no explicit connection or relationship between these two tables based on the provided schema.
Prompt: count the number of rows in outages
....
Description: The user wants to know the total number of entries recorded in the outages table.
Query: SELECT COUNT(*) FROM `main`.`default`.`outages`
Do you want to execute the query? Y/N [Y]: y
Executing query.
Renamed column: count(1) to: count_1_
Query result header:
    count_1_
    ________
      1468  
Save the table to base workspace? Y/N [Y]: y
Table variable name: outages_count
Prompt: quit chat
Quitting chat.

% In base MATLAB workspace
outages_count
outages_count =
  table
    count_1_
    ________
      1468  
```

>Again, note that the high-level chatbot integration is a preview feature, for example
>arbitrary table content conversion is not fully supported.
>For support contact <databricks@mathworks.com>.

[//]: #  (Copyright 2025 The MathWorks, Inc.)
