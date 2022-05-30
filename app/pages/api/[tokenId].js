export default function handler(req, res) {
    // get the tokenId from the query params
    const tokenId = req.query.tokenId;
    // All the images are uploaded on github so we can extract the images from github directly.
    const image_url = "https://raw.githubusercontent.com/d3vd00m/NFT-Collection/main/app/public/cryptodevs/";
    // The api is sending back metadata for a Crypto Dev
    // To make our collection compatible with Opensea, we need to follow some Metadata standards
    // when sending back the response from the api
    // More info can be found here: https://docs.opensea.io/docs/metadata-standards
    res.status(200).json({
        name: "Crypto Dev #" + tokenId,
        description: "Crypto Dev is a collection of developers in crypto",
        image: image_url + tokenId + ".svg",
    });
}
