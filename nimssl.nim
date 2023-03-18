import std/[asyncdispatch, httpclient]

proc asyncProc(): Future[string] {.async.} =
    var client = newAsyncHttpClient()
    return await client.getContent("https://www.google.ca")

echo waitFor asyncProc()
