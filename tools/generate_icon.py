from PIL import Image, ImageDraw, ImageFont
import os

def create_wallet_icon(size=1024):
    # Criar imagem com fundo branco
    image = Image.new('RGB', (size, size), 'white')
    draw = ImageDraw.Draw(image)
    
    # Desenhar carteira (retângulo vermelho arredondado)
    margin = size * 0.15
    wallet_width = size * 0.7
    wallet_height = size * 0.5
    wallet_x = margin
    wallet_y = size * 0.25
    
    draw.rounded_rectangle(
        [(wallet_x, wallet_y), 
         (wallet_x + wallet_width, wallet_y + wallet_height)],
        radius=size * 0.1,
        fill='#EF5350'  # Material Red 400
    )
    
    # Desenhar notas de dinheiro (retângulos brancos)
    note_width = size * 0.5
    note_height = size * 0.1
    
    draw.rounded_rectangle(
        [(size * 0.25, size * 0.2),
         (size * 0.25 + note_width, size * 0.2 + note_height)],
        radius=size * 0.02,
        fill='white'
    )
    
    draw.rounded_rectangle(
        [(size * 0.2, size * 0.15),
         (size * 0.2 + note_width, size * 0.15 + note_height)],
        radius=size * 0.02,
        fill='white'
    )
    
    # Tentar carregar uma fonte
    try:
        font = ImageFont.truetype("Arial", size=int(size * 0.2))
    except:
        font = ImageFont.load_default()
    
    # Desenhar símbolo R$
    text = "R$"
    text_width = draw.textlength(text, font=font)
    text_x = (size - text_width) / 2
    text_y = size * 0.35
    
    draw.text(
        (text_x, text_y),
        text,
        font=font,
        fill='white'
    )
    
    # Salvar a imagem
    os.makedirs('assets/icon', exist_ok=True)
    image.save('assets/icon/icon.png', 'PNG')
    
    # Criar tamanhos para Android
    sizes = {
        'mdpi': 48,
        'hdpi': 72,
        'xhdpi': 96,
        'xxhdpi': 144,
        'xxxhdpi': 192
    }
    
    for dpi, dpi_size in sizes.items():
        resized = image.resize((dpi_size, dpi_size), Image.Resampling.LANCZOS)
        os.makedirs(f'android/app/src/main/res/mipmap-{dpi}', exist_ok=True)
        resized.save(f'android/app/src/main/res/mipmap-{dpi}/ic_launcher.png', 'PNG')

if __name__ == '__main__':
    create_wallet_icon()
