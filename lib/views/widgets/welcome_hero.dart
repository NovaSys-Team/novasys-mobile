import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/auth_theme.dart';
import 'auth_details.dart';

/// Maps the 390pt design width onto the current screen so the illustrations
/// keep their reference proportions on any Android device.
double designScale(BuildContext context) =>
    MediaQuery.sizeOf(context).width.clamp(0.0, 480.0) / 390;

/// White rounded badge plus the NovaSys wordmark, used on the dark headers.
class NovaSysWordmark extends StatelessWidget {
  const NovaSysWordmark({super.key, this.scale = 1, this.box = 48});
  final double scale;
  final double box;
  @override
  Widget build(BuildContext context) {
    final side = box * scale;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: side,
          height: side,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(side * .29),
          ),
          child: Center(child: NovaSysMark(size: side * .45)),
        ),
        SizedBox(width: 13 * scale),
        Text(
          'NovaSys',
          style: TextStyle(
            color: Colors.white,
            fontSize: (box == 48 ? 26 : 24) * scale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Tall illustrated header for the Welcome screen (P01).
///
/// The artwork keeps its design proportions against the screen width, while the
/// wordmark stays anchored to the bottom of the band so the header can grow or
/// shrink with the height the layout can spare.
class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key, required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    final scale = designScale(context);
    return SizedBox(
      height: height,
      child: ClipRect(
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: AuthTheme.deep)),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.string(
                _welcomeArtwork,
                height: 330 * scale,
                fit: BoxFit.fill,
                excludeFromSemantics: true,
              ),
            ),
            Positioned(
              left: 24 * scale,
              bottom: 32 * scale,
              child: NovaSysWordmark(scale: scale),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact illustrated header reused by the role selection screen.
class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key, this.height, this.onBack});
  final double? height;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) {
    final scale = designScale(context);
    return SizedBox(
      height: height ?? 296 * scale,
      child: ClipRect(
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: AuthTheme.deep)),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.string(
                _journeyArtwork,
                height: 187 * scale,
                fit: BoxFit.fill,
                excludeFromSemantics: true,
              ),
            ),
            Positioned(
              left: 24 * scale,
              top: 228 * scale,
              child: NovaSysWordmark(scale: scale, box: 40),
            ),
            if (onBack != null)
              Positioned(
                left: 24,
                top: 24,
                child: IconButton.outlined(
                  onPressed: onBack,
                  tooltip: 'Back',
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF83A7A2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.chevron_left),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Decorative 390x330 school-bus illustration from the Welcome reference.
// Artwork only: no screen chrome and no interactive elements.
const _welcomeArtwork = r'''<svg width="390" height="330" viewBox="0 0 390 330" fill="none" xmlns="http://www.w3.org/2000/svg">
<path opacity="0.45" d="M330 230C407.32 230 470 167.32 470 90C470 12.6801 407.32 -50 330 -50C252.68 -50 190 12.6801 190 90C190 167.32 252.68 230 330 230Z" fill="#0A7C70"/>
<path opacity="0.25" d="M40 130C78.6599 130 110 98.6599 110 60C110 21.3401 78.6599 -10 40 -10C1.34007 -10 -30 21.3401 -30 60C-30 98.6599 1.34007 130 40 130Z" fill="#0E9F8E"/>
<path d="M-10 310C-9.68945 309.827 -9.37926 309.657 -9.06943 309.487M410 270C409.707 269.824 409.414 269.649 409.121 269.474M11.7864 300.29C12.4369 300.071 13.086 299.859 13.7336 299.653M36.006 294.92C36.69 294.844 37.3727 294.774 38.0541 294.71M60.8315 294.636C61.522 294.69 62.2116 294.749 62.9001 294.813M85.4314 298.232C86.109 298.367 86.786 298.505 87.4625 298.645M109.701 303.68C110.375 303.837 111.048 303.994 111.721 304.15M134.037 308.821C134.717 308.939 135.399 309.055 136.081 309.167M158.749 311.456C159.438 311.475 160.129 311.488 160.82 311.495M183.5 309.599C184.173 309.474 184.847 309.343 185.523 309.204M207.244 302.406C207.872 302.139 208.501 301.866 209.131 301.586M229.112 290.588C229.408 290.394 229.704 290.198 230 290C230.288 289.808 230.576 289.616 230.863 289.426M249.768 277.458C250.35 277.109 250.93 276.763 251.508 276.421M271.061 265.627C271.67 265.318 272.276 265.013 272.879 264.712M293.291 255.669C293.919 255.429 294.544 255.194 295.166 254.963M316.603 248.655C317.264 248.516 317.921 248.382 318.575 248.254M340.782 246.152C341.463 246.16 342.142 246.175 342.819 246.196M364.871 249.427C365.526 249.598 366.179 249.775 366.831 249.958M387.691 257.886C388.301 258.173 388.91 258.464 389.52 258.76" stroke-width="10" stroke-linecap="round" stroke="#0E9F8E"/>
<path d="M78 291C82.9706 291 87 286.971 87 282C87 277.029 82.9706 273 78 273C73.0294 273 69 277.029 69 282C69 286.971 73.0294 291 78 291Z" fill="white"/>
<path d="M78 286C80.2091 286 82 284.209 82 282C82 279.791 80.2091 278 78 278C75.7909 278 74 279.791 74 282C74 284.209 75.7909 286 78 286Z" fill="#0B3B3A"/>
<path d="M300 265C304.971 265 309 260.971 309 256C309 251.029 304.971 247 300 247C295.029 247 291 251.029 291 256C291 260.971 295.029 265 300 265Z" fill="#FF7A59"/>
<path d="M250 198H166C156.059 198 148 206.059 148 216V248C148 257.941 156.059 266 166 266H250C259.941 266 268 257.941 268 248V216C268 206.059 259.941 198 250 198Z" fill="#FF7A59"/>
<path d="M183 210H165C162.239 210 160 212.239 160 215V225C160 227.761 162.239 230 165 230H183C185.761 230 188 227.761 188 225V215C188 212.239 185.761 210 183 210Z" fill="#FFF4EF"/>
<path d="M217 210H199C196.239 210 194 212.239 194 215V225C194 227.761 196.239 230 199 230H217C219.761 230 222 227.761 222 225V215C222 212.239 219.761 210 217 210Z" fill="#FFF4EF"/>
<path d="M251 210H233C230.239 210 228 212.239 228 215V225C228 227.761 230.239 230 233 230H251C253.761 230 256 227.761 256 225V215C256 212.239 253.761 210 251 210Z" fill="#FFF4EF"/>
<path d="M268 240H148V248H268V240Z" fill="#E8603F"/>
<path d="M176 279C182.075 279 187 274.075 187 268C187 261.925 182.075 257 176 257C169.925 257 165 261.925 165 268C165 274.075 169.925 279 176 279Z" fill="#0F2A29"/>
<path d="M176 272.5C178.485 272.5 180.5 270.485 180.5 268C180.5 265.515 178.485 263.5 176 263.5C173.515 263.5 171.5 265.515 171.5 268C171.5 270.485 173.515 272.5 176 272.5Z" fill="#DCE5E3"/>
<path d="M240 279C246.075 279 251 274.075 251 268C251 261.925 246.075 257 240 257C233.925 257 229 261.925 229 268C229 274.075 233.925 279 240 279Z" fill="#0F2A29"/>
<path d="M240 272.5C242.485 272.5 244.5 270.485 244.5 268C244.5 265.515 242.485 263.5 240 263.5C237.515 263.5 235.5 265.515 235.5 268C235.5 270.485 237.515 272.5 240 272.5Z" fill="#DCE5E3"/>
</svg>''';

// Compact 390x187 variant of the same illustration, used on inner headers.
const _journeyArtwork = r'''<svg width="390" height="187" viewBox="0 0 390 187" fill="none" xmlns="http://www.w3.org/2000/svg">
<path opacity="0.45" d="M330 120C396.274 120 450 66.2742 450 0C450 -66.2742 396.274 -120 330 -120C263.726 -120 210 -66.2742 210 0C210 66.2742 263.726 120 330 120Z" fill="#0A7C70"/>
<path opacity="0.25" d="M40 30C73.1371 30 100 3.13708 100 -30C100 -63.1371 73.1371 -90 40 -90C6.86292 -90 -20 -63.1371 -20 -30C-20 3.13708 6.86292 30 40 30Z" fill="#0E9F8E"/>
<path d="M-10 180C-9.68945 179.827 -9.37926 179.657 -9.06943 179.487M410 140C409.707 139.824 409.414 139.649 409.121 139.474M11.7864 170.29C12.4369 170.071 13.086 169.859 13.7336 169.653M36.006 164.92C36.69 164.844 37.3727 164.774 38.0541 164.71M60.8315 164.636C61.522 164.69 62.2116 164.749 62.9001 164.813M85.4314 168.232C86.109 168.367 86.786 168.505 87.4625 168.645M109.701 173.68C110.375 173.837 111.048 173.994 111.721 174.15M134.037 178.821C134.717 178.939 135.399 179.055 136.081 179.167M158.749 181.456C159.438 181.475 160.129 181.488 160.82 181.495M183.5 179.599C184.173 179.474 184.847 179.343 185.523 179.204M207.244 172.406C207.872 172.139 208.501 171.866 209.131 171.586M229.112 160.588C229.408 160.394 229.704 160.198 230 160C230.288 159.808 230.576 159.616 230.863 159.426M249.768 147.458C250.35 147.109 250.93 146.763 251.508 146.421M271.061 135.627C271.67 135.318 272.276 135.013 272.879 134.712M293.291 125.669C293.919 125.429 294.544 125.194 295.166 124.963M316.603 118.655C317.264 118.516 317.921 118.382 318.575 118.254M340.782 116.152C341.463 116.16 342.142 116.175 342.819 116.196M364.871 119.427C365.526 119.598 366.179 119.775 366.831 119.958M387.691 127.886C388.301 128.173 388.91 128.464 389.52 128.76" stroke-width="10" stroke-linecap="round" stroke="#0E9F8E"/>
<path d="M78 161C82.9706 161 87 156.971 87 152C87 147.029 82.9706 143 78 143C73.0294 143 69 147.029 69 152C69 156.971 73.0294 161 78 161Z" fill="white"/>
<path d="M78 156C80.2091 156 82 154.209 82 152C82 149.791 80.2091 148 78 148C75.7909 148 74 149.791 74 152C74 154.209 75.7909 156 78 156Z" fill="#0B3B3A"/>
<path d="M300 135C304.971 135 309 130.971 309 126C309 121.029 304.971 117 300 117C295.029 117 291 121.029 291 126C291 130.971 295.029 135 300 135Z" fill="#FF7A59"/>
<path d="M246 98H182C174.268 98 168 104.268 168 112V136C168 143.732 174.268 150 182 150H246C253.732 150 260 143.732 260 136V112C260 104.268 253.732 98 246 98Z" fill="#FF7A59"/>
<path d="M196 108H182C179.791 108 178 109.791 178 112V120C178 122.209 179.791 124 182 124H196C198.209 124 200 122.209 200 120V112C200 109.791 198.209 108 196 108Z" fill="#FFF4EF"/>
<path d="M222 108H208C205.791 108 204 109.791 204 112V120C204 122.209 205.791 124 208 124H222C224.209 124 226 122.209 226 120V112C226 109.791 224.209 108 222 108Z" fill="#FFF4EF"/>
<path d="M246 108H234C231.791 108 230 109.791 230 112V120C230 122.209 231.791 124 234 124H246C248.209 124 250 122.209 250 120V112C250 109.791 248.209 108 246 108Z" fill="#FFF4EF"/>
<path d="M260 132H168V138H260V132Z" fill="#E8603F"/>
<path d="M190 161C194.971 161 199 156.971 199 152C199 147.029 194.971 143 190 143C185.029 143 181 147.029 181 152C181 156.971 185.029 161 190 161Z" fill="#0F2A29"/>
<path d="M190 155.5C191.933 155.5 193.5 153.933 193.5 152C193.5 150.067 191.933 148.5 190 148.5C188.067 148.5 186.5 150.067 186.5 152C186.5 153.933 188.067 155.5 190 155.5Z" fill="#DCE5E3"/>
<path d="M240 161C244.971 161 249 156.971 249 152C249 147.029 244.971 143 240 143C235.029 143 231 147.029 231 152C231 156.971 235.029 161 240 161Z" fill="#0F2A29"/>
<path d="M240 155.5C241.933 155.5 243.5 153.933 243.5 152C243.5 150.067 241.933 148.5 240 148.5C238.067 148.5 236.5 150.067 236.5 152C236.5 153.933 238.067 155.5 240 155.5Z" fill="#DCE5E3"/>
</svg>''';
