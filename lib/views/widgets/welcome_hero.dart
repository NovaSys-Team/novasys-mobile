import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth_details.dart';

class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key, this.height, this.onBack});
  final double? height;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.sizeOf(context).width.clamp(0.0, 480.0) / 390;
    return SizedBox(
      height: height ?? 296 * scale,
      child: ClipRect(
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Color(0xFF0B3B3A))),
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
              child: Row(
                children: [
                  Container(
                    width: 40 * scale,
                    height: 40 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: NovaSysMark()),
                  ),
                  SizedBox(width: 10 * scale),
                  Text(
                    'NovaSys',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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

// Only the decorative 390x187 illustration, not a screen or interactive UI.
// Placement and header proportions follow the supplied auth screenshots.
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
