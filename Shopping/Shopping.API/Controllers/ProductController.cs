using Microsoft.AspNetCore.Mvc;
using System.Linq;
using Shopping.API.Models;
using Shopping.API.Data;

namespace Shopping.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly ILogger<ProductController> _logger;
        public ProductController(ILogger<ProductController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public ActionResult<IEnumerable<Product>> Get()
        {
            _logger.LogInformation("Fetching all products");
            return Ok(GetProducts());
        }

        [HttpGet("{id}")]
        public ActionResult<Product> GetById(string id)
        {
            var product = GetProducts().FirstOrDefault(p => p.Id == id);

            if (product is null)
            {
                _logger.LogWarning("Product with id {ProductId} not found", id);
                return NotFound();
            }

            return Ok(product);
        }

        private IEnumerable<Product> GetProducts()
        {
            return ProductContext.Products;         

        }
    }
}
