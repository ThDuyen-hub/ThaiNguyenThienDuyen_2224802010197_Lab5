using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using TodoApi.Data;
using TodoApi.Models;

namespace TodoApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public AuthController(
            AppDbContext context,
            IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        // ================= REGISTER =================
        [HttpPost("register")]
        public IActionResult Register(User user)
        {
            // kiểm tra email đã tồn tại chưa
            var checkUser = _context.Users
                .FirstOrDefault(x => x.Email == user.Email);

            if (checkUser != null)
            {
                return BadRequest(new
                {
                    message = "Email already exists"
                });
            }

            // thêm user mới
            _context.Users.Add(user);

            _context.SaveChanges();

            return Ok(new
            {
                message = "Register Success"
            });
        }

        // ================= LOGIN =================
        [HttpPost("login")]
        public IActionResult Login(User loginUser)
        {
            var user = _context.Users
                .FirstOrDefault(x =>
                    x.Email == loginUser.Email &&
                    x.Password == loginUser.Password);

            if (user == null)
            {
                return Unauthorized(new
                {
                    message = "Invalid account"
                });
            }

            // tạo claim
            var claims = new[]
            {
                new Claim(
                    ClaimTypes.NameIdentifier,
                    user.Id.ToString()
                ),

                new Claim(
                    ClaimTypes.Email,
                    user.Email
                )
            };

            // lấy JWT key
            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(
                    _config["Jwt:Key"]!
                )
            );

            // tạo credentials
            var creds = new SigningCredentials(
                key,
                SecurityAlgorithms.HmacSha256
            );

            // tạo token
            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],

                claims: claims,

                expires: DateTime.Now.AddDays(1),

                signingCredentials: creds
            );

            return Ok(new
            {
                token = new JwtSecurityTokenHandler()
                    .WriteToken(token),

                user = new
                {
                    user.Id,
                    user.Email
                }
            });
        }
    }
}