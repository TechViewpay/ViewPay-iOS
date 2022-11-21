
# ViewPay iOS SDK: Guide de démarrage

Ce guide a pour objectif de vous guider dans la mise en place du SDK ViewPay dans votre application iOS en `Swift` ou `Objective-C`.
Pour rappel, Viewpay est une solution de micro-paiement par l'attention publicitaire, qui permet à l'utilisateur de débloquer un contenu premium en regardant une publicité. Viewpay a pour vocation d'être une alternative à d'autres options pour débloquer un contenu premium, et ne doit pas être installé comme seule option d'un paywall.

Voici un exemple de déblocage d'article avec Viewpay : 

![sample](https://github.com/TechViewpay/ViewPay-iOS/blob/master/DocImages/parcours_vp_mobile3.png?raw=true)

## Prérequis 

- Utiliser Xcode 13.0 ou supérieur 
- Compatibilité iOS 10.0 ou supérieur

## Installation du SDK

### Cocoapods (recommandé)

Pour une simplifier l'installation et la mise à jour de vos librairies externes nous vous conseillons d'utiliser [Cocoapods](https://www.cocoapods.org).

Dans votre fichier `Podfile` ajouter la référence au SDK ViewPay:

```
pod 'ViewPay-iOS-SDK'
```

Puis, lancez la commande `pod install`.

Afin de maintenir le SDK à jour executez la commande `pod update` avant chaque mise à jour de votre application.

### Installation manuelle

Si vous ne souhaitez pas utiliser Cocoapods vous pouvez installer le SDK manuellement :

- Téléchargez la dernière version du SDK via le lien suivant : [ViewPay.zip](https://github.com/TechViewpay/ViewPay-iOS/blob/master/Dist/ViewPay.zip?raw=true)
- Décompressez l'archive
- Glissez le fichier `ViewPay.xcframework` dans votre projet, sélectionnez l'option `Destination: Copy items if needed` et ajoutez le fichier à la target principale de votre projet.
- Téléchargez et installez la dernière version du SDK Google IMA utilisé par ViewPay en suivant les instructions sur le [portail développeur de Google](https://developers.google.com/interactive-media-ads/docs/sdks/ios/)

Enfin, pour terminer l'installation vous devez ajouter une étape scrip dans la configuration de votre build :

- Rendez-vous dans la configuration de votre projet, sélectionnez votre target principale, onglet `Build Phases`, ajouter une étape en cliquant sur le `+` en haut à gauche, selectionnez `New Run Script Phase`.
- Ouvrez le détail de la nouvelle étape à l'aide de la petite flèche et dans le contenu de l'étape entrez le script suivant: 
```
EXEC="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/ViewPay.xcframework/ViewPay"

archs="$(lipo -info "${EXEC}" | rev | cut -d ':' -f1 | rev)"
stripped=""
for arch in $archs; do
if ! [[ "${VALID_ARCHS}" == *"$arch"* ]]; then
lipo -remove "$arch" -output "${EXEC}" "${EXEC}" || exit 1
stripped="$stripped $arch"
fi
done

echo "Architecture(s) ${stripped} have been removed from binary."
```
- Si vous le souhaitez vous pouvez renommer la phase en double cliquant sur le titre (par défaut "Run Script") afin de lui donner un nom plus facilement reconnaissable.

## Initialisation du SDK

Pour que le SDK puisse fonctionner, vous devez l'initialiser aussi tôt que possible dans le cycle de vie de votre application.

- Commencez tout d'abord par importer le SDK dans l'entête de votre `ApplicationDelegate` avant le début de la déclaration de la `class`: 
	- `import ViewPay` en Swift.
	- `#import <ViewPay/ViewPay.h>` en Objective-C.
- Ensuite, dans la méthode `application:didFinishLaunchingWithOptions:`, initialisez le SDK avec l'identifiant qui vous a été fourni par la régie ViewPay de la manière suivante:
	- `ViewPay.setAccountID("<votre_ID>")` en Swift.
	- `[ViewPay setAccountID:@"<votre_ID>];"` en Objective-C.

## Vérification de la disponibilité des campagnes

Une fois le SDK initialisé, la première étape dans l'utilisation du SDK est de vérifier au moment opportun la disponibilité d'une ou plusieurs campagnes

Pour cela, vous devez appeler la méthode `checkVideoWithContentCategory:andCallback:`.

Si le callback retourne un succès, alors vous pouvez mettre à jour l'interface (affichage bouton par exemple) pour proposer à l'utilisateur de "payer" la transaction en visionnant une video.

en Swift:

```swift
ViewPay.checkVideo(withContentCategory: nil) { (success, error) in
	if (success) {
		// Des campagnes sont disponibles
		// Faites apparaitre le bouton dans votre paywall permettant à l'utilisateur d'accèder à son contenu via ViewPay.
	}
	else {
		// Aucune campagne n'est disponible. Vos autres alternatives de payement sont toujours proposées à votre utilisateur.
	}   
}
```

en Objective-C:

```objective-c
[ViewPay checkVideoWithContentCategory:nil
		andCallback:^(BOOL success, NSError *error) {
			if (success) {
				// Des campagnes sont disponibles.
				// Faites apparaitre le bouton dans votre paywall permettant à l'utilisateur d'accèder à son contenu via ViewPay.
			}
			else {
				// Aucune campagne n'est disponible. Vos autres alternatives de payement sont toujours proposées à votre utilisateur.
			} 
}];
```

## Présenter la publicité afin d'accéder au contenu

Grace au callback de l'appel à la méthode `checkVideoWithContentCategory:andCallback:`, vous êtes en mesure de savoir si des publicités sont disponible pour valider la transaction via ViewPay.

Lorsque l'utilisateur va choisir l'option Viewpay en cliquant sur le bouton dans le paywall, l'étape suivante consiste donc à présenter l'AdSelector ViewPay à l'utilisateur pour lui permettre de choisir et visionner une publicité video.

Pour cela, vous devez appeler la méthode `presentAdWithCallback:`:

en Swift :

```swift
ViewPay.presentAd { (status) in
	if status == .success {
		// Autorisez l'utilisateur à accéder à son contenu.
	}             
}
```

en Objective-C :

```objective-c
[ViewPay presentAdWithCallback:^(VPAdStatus status) {
	if (status == VPAdStatusSuccess) {
		// Autorisez l'utilisateur à accéder à son contenu.
	}
}];
```

## Gestion d'erreur

Le callback de la méthode `presentAd:withContentCategory:andCallback:` vous permet de présenter un feedback adapté à l'utilisateur parmi les possibilitées suivantes :

- `VPAdStatusSuccess` en Objective-C ou `VPAdStatus.success` en Swift: atteste du bon déroulement de la transaction. L'utilisateur a visionné la publicité jusqu'au bout et peut accéder à son contenu.
- `VPAdStatusCancelled` en Objective-C ou `VPAdStatus.cancelled` en Swift: l'utilisateur a quitté l'écran de publicité avant la fin du visionnage de celle-ci. Il a déjà été informé par le SDK qu'il ne pourra pas accéder à son contenu.
- `VPAdStatusNoAd` en Objective-C ou `VPAdStatus.noAd` en Swift: Aucune publicité n'est disponible pour valider la transaction. L'appel est transparent pour l'utilisateur. Utilisez une autre alternative pour valider la transaction d'accès au contenu.
- `VPAdStatusError` en Objective-C ou `VPAdStatus.error` en Swift: une erreur s'est produite lors de la présentation de la publicité. Présentez un feedback adapté à l'utilisateur et utilisez une autre alternative pour valider la transaction d'accès au contenu.

## Méta-Données et customisation

Le SDK ViewPay remonte un certain nombre de meta données pour permettre une meilleur catégorisation des publicités présentées à l'utilisateur.

Si ces informations sont disponibles dans votre application vous pouvez facilement renseigner le genre et l'âge de l'utilisateur à l'aide des 2 méthodes suivantes:

en Swift :

```swift
ViewPay.setUserAge(42)
ViewPay.setUserGender(.male) // valeurs disponibles: .male, .female ou .other
```

en Objective-C :

```objective-c
[ViewPay setUserAge:42];
[ViewPay setUserGender:VPUserGenderMale]; // valeurs disponibles: VPUserGenderMale, VPUserGenderFemale ou VPUserGenderOther
```

Vous pouvez également, lors de l'appel à la méthode `checkVideoWithContentCategory:andCallback:` renseigner la catégorie du contenu sous la forme d'une chaîne de caractères de votre choix afin de fournir un maximum de contexte :

en Swift :

```swift
ViewPay.checkVideo(withContentCategory: "cinema") { (success, error) in
	if success {
		...
	}             
}
```

en Objective-C :


```objective-c
[ViewPay checkVideoWithContentCategory:@"cinema" 
	andCallback:^(BOOL success, NSError *error) {
		if (success) {
			...
		} 
}];
```

Particulierement, le meta données "pageInfo", qui est composé par l'id et le nom de la page, sert à catégoriser les statstiques des publicités visualisés par page. 

vous pouvez le renseigner comme ceci :

en swift :

```swift
ViewPay.setPageInfo("652", pageTitle: "Page actualites guerre en ukraine") 
```

en Objective-C :

```objective-c
[ViewPay setPageInfo:@"6565" pageTitle:@"Page actualites guerre en ukraine"];
```
