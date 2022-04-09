addEventListener("fetch", event => {
    event.respondWith(forward(event.request))
})

async function forward(request) {
    let headers = new Headers()
    for(const [key, value] of request.headers) {
        if(key.toLowerCase().startsWith("cf-")
            || key.toLowerCase() == "x-forwarded-for"
            || key.toLowerCase() == "x-real-ip")
            continue
        headers.append(key, value)
    }

    try {
        headers.set("Referer", REFERER)
    } catch(e) {
        console.debug(e.message)
    }

    const url = new URL(request.url)
    const address = request.url.replace(url.hostname,
                                        DESTINATION_HOST)

    if(url.pathname == "/robots.txt") {
        response_body = "User-agent: *\r\nDisallow: /"
        return new Response(response_body)
    }

    const init = {
        body: request.body,
        headers: headers,
        method: request.method
    }

    let response = await fetch(address, init)
    return new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers: response.headers
    })
}
