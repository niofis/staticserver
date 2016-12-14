import asynchttpserver, asyncfile, os, asyncdispatch

var server = newAsyncHttpserver()
proc cb(req: Request) {.async.} =
  var file =  "." & req.url.path

  echo file

  if file == "./":
    file &= "index.html"

  if os.fileExists(file):
      var file = openAsync(file, fmRead)
      let data = await file.readAll()
      file.close()
      await req.respond(Http200, data)
  else:
    await req.respond(Http404, "Not Found!")


waitFor server.serve(Port(9080), cb)
