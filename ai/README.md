## AI Layer: Tableau Public MCP Integration
### Overview
This project includes an AI-oriented extension using Tableau Public MCP.
The goal is to enable an MCP-compatible client to inspect and interact with the published Tableau Public dashboard programmatically.
### Why this approach
Because the dashboards are published on Tableau Public, a Tableau-focused MCP server is a natural extension for exploring workbook metadata, views, screenshots, and structure.
### Reference implementation
This integration is based on the Tableau Public MCP Server by wjsutton:
Tableau Public MCP Server repository
#### Prerequisites
Node.js 20+
An MCP-compatible client such as Claude Desktop
Example MCP configuration
{
  "mcpServers": {
    "tableau-public": {
      "command": "npx",
      "args": ["-y", "@wjsutton/tableau-public-mcp-server@latest"]
    }
  }
}

### Example use cases
Inspect workbook details for the published dashboard
Retrieve workbook contents and views
Fetch screenshots of specific views
Build dashboard documentaion
Ask an AI client to explain the dashboard structure and key insights
Example prompts
"Get the details of my published Tableau Public workbook."
"List the views available in this workbook."
"Explain the main revenue insights shown in this dashboard."
"Fetch an image of the Executive Overview dashboard."
### Notes
This MCP layer is an optional enhancement. The core analytics project remains the dbt + BigQuery + Tableau workflow.
That MCP config matches the repo’s documented quick-start pattern using npx and the published package name. (GitHub)
